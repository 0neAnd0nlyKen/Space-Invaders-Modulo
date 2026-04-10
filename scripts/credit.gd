extends Control

@onready var back_button = $BackButton
@onready var click_sound = $ClickSound

func _ready():
	back_button.grab_focus()

func _on_back_button_pressed():
	click_sound.play()
	print("Back to main menu")
	await click_sound.finished #sound diklick ya
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
