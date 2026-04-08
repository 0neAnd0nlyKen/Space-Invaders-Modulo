extends Control

@onready var back_button = $BackButton

func _ready():
	back_button.grab_focus()

func _on_back_button_pressed():
	print("Back to main menu")
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
