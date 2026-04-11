extends Control
class_name GameplayOverlay

@export var health_Label: Label
@export var score_Label: Label
@export var highscore_Label: Label

func _ready() -> void:
	var scores = load_scores()
	var highscore = scores[0]["score"]
	update_highscore_label(highscore)

func load_scores() -> Array:
	if not FileAccess.file_exists("user://scores.json"):
		return []
		
	var file = FileAccess.open("user://scores.json", FileAccess.READ)
	var data = JSON.parse_string(file.get_as_text())
	file.close()
	return data if data != null else []

func update_health_label(hp: float):
	health_Label.text = "hp\n %f" % hp
	
func update_score_label(score: int):
	score_Label.text = "score\n %d" % score
	
func update_highscore_label(highscore: int):
	print_debug(highscore)
	highscore_Label.text = "highscore\n %d" % highscore
