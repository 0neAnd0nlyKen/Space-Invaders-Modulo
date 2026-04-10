extends Control
@onready var click_sound = $ClickSound

func _input(event):
	if event.is_action_pressed("ui_accept"):
		click_sound.play()
		await click_sound.finished
		get_tree().change_scene_to_file("res://scenes/story2.tscn")
