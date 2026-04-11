extends Control

@onready var click_sound = $ClickSound
@onready var textField = $TextField
var playerName: String

func _on_text_field_text_submitted(new_text: String) -> void:
	SelectionInstructions.playerDetail = {
			"name": new_text,
			"score": 0,
		}
	if name != null:
		click_sound.play()
		await click_sound.finished
		get_tree().change_scene_to_file("res://scenes/story1.tscn")
