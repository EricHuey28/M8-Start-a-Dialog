extends Control

var expressions := {
	"happy": preload ("res://assets/emotion_happy.png"),
	"regular": preload ("res://assets/emotion_regular.png"),
	"sad": preload ("res://assets/emotion_sad.png"),
}

var bodies := {
	"sophia": preload ("res://assets/sophia.png"),
	"pink": preload ("res://assets/pink.png")
}


var dialogue_items: Array[Dictionary] = [
	{
		"expression": expressions["regular"],
		"text": "[wave]What it do flight crew [/wave]",
		"character": bodies["sophia"],
		"choices": {
			"Good": 1.5,
			"Not Good": 1.5
		}
	},
	{
		"expression": expressions["regular"],
		"text": "Bad, I couldn't find John Pork",
		"character": bodies["pink"],
		"choices": {
			"Let me help": 1,
			"Can't do anything about that": -1
		}
	},
	{
		"expression": expressions["sad"],
		"text": "[shake]Nice to see[/shake]!",
		"character": bodies["sophia"],
		"choices": {
			"How about you?": 1,
			"Quit": -1
		}
	},
	{
		"expression": expressions["sad"],
		"text": "",
		"character": bodies["pink"]
	},
	{
		"expression": expressions["regular"],
		"text": "we dit it",
		"character": bodies["pink"]
	},
	{
		"expression": expressions["happy"],
		"text": "fire",
		"character": bodies["pink"]
	},
	{
		"expression": expressions["happy"],
		"text": "[tornado freq=3.0][rainbow val=1.0]flip!!![/rainbow][/tornado]",
		"character": bodies["sophia"]
	}
]

@onready var rich_text_label: RichTextLabel = %RichTextLabel
@onready var action_buttons_v_box_container: VBoxContainer = %ActionButtonsVBoxContainer
@onready var audio_stream_player: AudioStreamPlayer = %AudioStreamPlayer
@onready var body: TextureRect = %Body
@onready var expression: TextureRect = %Expression


func _ready() -> void:
	show_text(0)
	


func show_text(current_item_index: int) -> void:
	var current_item := dialogue_items[current_item_index]
	
	rich_text_label.text = current_item["text"]
	expression.texture = current_item["expression"]
	
	body.texture = current_item["character"]
	rich_text_label.visible_ratio = 1
	var tween := create_tween()
	
	var text_appearing_duration: float = current_item["text"].length() / 30.0
	
	var sound_max_offset := audio_stream_player.stream.get_length() - text_appearing_duration
	var sound_start_position := randf() * sound_max_offset
	audio_stream_player.play(sound_start_position)
	
	tween.finished.connect(audio_stream_player.stop)
	
	slide_in()
	
	for button: Button in action_buttons_v_box_container.get_children():
		button.disabled = true
	tween.finished.connect(func() -> void:
		for button: Button in action_buttons_v_box_container.get_children():
			button.disabled = false
	)
	
	if current_item.has("choices"):
		create_buttons(current_item["choices"])
	else:
		var button := Button.new()
		action_buttons_v_box_container.add_child(button)
		button.text = "Next"
		
		var next_item_index: int = current_item_index + 1
		if next_item_index >= dialogue_items.size():
			button.pressed.connect(get_tree().quit)
		else:
			button.pressed.connect(show_text.bind(next_item_index))

func create_buttons(choices_data: Dictionary) -> void:
	for button in action_buttons_v_box_container.get_children():
		button.queue_free()
		
	for choice_text in choices_data:
		var button := Button.new()
		action_buttons_v_box_container.add_child(button)
		button.text = choice_text
		
		var target_line_idx: int = choices_data[choice_text]
		if target_line_idx == - 1:
			
			button.pressed.connect(get_tree().quit)
		else:
			button.pressed.connect(show_text.bind(target_line_idx))
func slide_in() -> void:
	
	var slide_tween := create_tween()
	slide_tween.set_ease(Tween.EASE_OUT)
	
	body.position.x = get_viewport_rect().size.x / 7
	
	slide_tween.tween_property(body, "position:x", 0, 0.3)
	body.modulate.a = 0
	
	slide_tween.parallel().tween_property(body, "modulate:a", 1, 0.2)
	
