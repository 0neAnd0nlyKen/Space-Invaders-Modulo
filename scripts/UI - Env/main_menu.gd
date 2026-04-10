extends Control

@onready var play_button = $PlayButton
@onready var credits_button = $CreditsButton
@onready var exit_button = $ExitButton
@onready var leaderboard_button = $LeaderboardButton
@onready var click_sound = $ClickSound #Ini pake soundnya

func _ready():
	# Set focus to play button by default
	BGM.play_music("res://assets/sound/SoundTetris.mp3")
	play_button.grab_focus()

func _on_play_pressed():
	click_sound.play() #Pake panggi fungsi sound
	print("Play button pressed - Starting game...")
	await click_sound.finished #sound diklick ya
	get_tree().change_scene_to_file("res://scenes/story1.tscn")

func _on_credits_pressed():
	click_sound.play()
	print("Credits button pressed - Showing credits...")
	await click_sound.finished
	get_tree().change_scene_to_file("res://scenes/credit.tscn")
	# For now, just show a simple message. You can create a credits scene later
	"""
SPACE INVADERS MODULO

Game by: [Your Name]
Engine: Godot 4.6
Assets: Custom

Thank you for playing!
"""

func _on_exit_pressed():
	click_sound.play()
	print("Exit button pressed - Quitting game...")
	await click_sound.finished
	get_tree().quit()

func _on_leaderboard_button_pressed():
	click_sound.play()
	print("leaderboard button pressed - Loading leaderboard...")
	await click_sound.finished
	get_tree().change_scene_to_file("res://scenes/leaderboard.tscn")
