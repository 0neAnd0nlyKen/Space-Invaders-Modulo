extends Control

@onready var playAgain = $PlayAgain
@onready var mainMenu = $BackToMenu
@onready var click_sound = $ClickSound

func _ready():
	BGM.play_music("res://assets/sound/SoundTetris.mp3")
	playAgain.grab_focus()

func _on_play_again_pressed() -> void:
	click_sound.play() #Pake panggi fungsi sound
	print("Resarting Mission: ... .. .. .")
	await click_sound.finished #sound diklick ya
	SelectionInstructions.data = {
		"type": 0,
		"next": "world",
		"title": "Choose Weapon"
	}
	get_tree().change_scene_to_file("res://scenes/selection_screen.tscn")

func _on_back_to_menu_pressed() -> void:
	click_sound.play()
	print("Aborting ... 3 .. 2 .. 1 ...")
	await click_sound.finished
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
