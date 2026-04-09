extends Control

func _input(event):
	if event.is_action_pressed("ui_accept"):
		SelectionInstructions.data = {
			"type": 0,
			"next": "world",
			"title": "Choose Weapon"
		}
		get_tree().change_scene_to_file("res://scenes/selection_screen.tscn")
