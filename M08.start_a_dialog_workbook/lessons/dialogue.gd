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
		"character": bodies["sophia"]
	},
	{
		"expression": expressions["regular"],
		"text": "How has it been going?",
		"character": bodies["pink"]
	},
	{
		"expression": expressions["sad"],
		"text": "... Well... it is a little bit [shake]complicated[/shake]!",
		"character": bodies["sophia"]
	},
	{
		"expression": expressions["sad"],
		"text": "Oh!",
		"character": bodies["pink"]
	},
	{
		"expression": expressions["regular"],
		"text": "I believe in you!",
		"character": bodies["pink"]
	},
	{
		"expression": expressions["happy"],
		"text": "If you stick to it, you'll eventually make it!",
		"character": bodies["pink"]
	},
	{
		"expression": expressions["happy"],
		"text": "That's it! Let's [tornado freq=3.0][rainbow val=1.0]GOOOOOO!!![/rainbow][/tornado]",
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
	rich_text_label.visible_ratio = 0.0
	var tween := create_tween()
	
	var text_appearing_duration: float = current_item["text"].length() / 30.0
	
	var sound_max_offset := audio_stream_player.stream.get_length() - text_appearing_duration
	var sound_start_position := randf() * sound_max_offset
	audio_stream_player.play(sound_start_position)
	tween.finished.connect(audio_stream_player.stop)
	
	slide_in()

func slide_in() -> void:
	var slide_tween := create_tween()
	slide_tween.set_ease(Tween.EASE_OUT)
	body.position.x = get_viewport_rect().size.x / 7
	slide_tween.tween_property(body, "position:x", 0, 0.3)
	body.modulate.a = 0
	slide_tween.parallel().tween_property(body, "modulate:a", 1, 0.2)
