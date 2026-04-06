extends Control

@onready var play_button = $PlayButton
@onready var credits_button = $CreditsButton
@onready var exit_button = $ExitButton
@onready var default_button = $DefaultButton

func _ready():
	# Set focus to play button by default
	play_button.grab_focus()

func _on_play_pressed():
	print("Play button pressed - Starting game...")
	get_tree().change_scene_to_file("res://scenes/world.tscn")

func _on_credits_pressed():
	print("Credits button pressed - Showing credits...")
	# For now, just show a simple message. You can create a credits scene later
	var credits_text = """
SPACE INVADERS MODULO

Game by: [Your Name]
Engine: Godot 4.6
Assets: Custom

Thank you for playing!
"""
	print(credits_text)

func _on_exit_pressed():
	print("Exit button pressed - Quitting game...")
	get_tree().quit()

func _on_default_pressed():
	print("Default button pressed - Loading default settings...")
