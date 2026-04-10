extends Control

@onready var back_button = $BackButton
@onready var click_sound = $ClickSound
@onready var highscoreList = $RichTextLabel

func _ready():
	back_button.grab_focus()
	display_leaderboard()

func display_leaderboard() -> void:
	var scores = load_scores()
	highscoreList.clear()
	for i in range(min(10, scores.size())):
		var entry = scores[i]
		#highscoreList.append_text(str(i + 1) + ". " + entry["name"] + ": " + str(entry["score"]) + "\n")
		highscoreList.append_text("[b]" + entry["name"] + "[/b]: [color=yellow]" + str(entry["score"]) + "[/color]\n")

func load_scores() -> Array:
	if not FileAccess.file_exists("user://scores.json"):
		return []
		
	var file = FileAccess.open("user://scores.json", FileAccess.READ)
	var data = JSON.parse_string(file.get_as_text())
	file.close()
	return data if data != null else []

func _on_back_button_pressed():
	click_sound.play()
	await click_sound.finished #sound diklick ya
	print("Back to main menu")
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
