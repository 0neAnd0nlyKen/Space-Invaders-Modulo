extends Node2D
class_name World
@export var score: int = 0
@export var health: int = 9
@export var healthLabel: Label
@export var scoreLabel: Label

func _ready() -> void:
	updateLabel(healthLabel, health)
	updateLabel(scoreLabel, score)

func updateLabel(label: Label, num: int):
	label.text = str(num)

func _on_enemy_defeated(enemyScore: int):
	score += enemyScore
	updateLabel(scoreLabel, score)
	print("detected death")

func _on_enemy_landed(enemyHealth: int):
	health -= enemyHealth
	updateLabel(healthLabel, health)
	if health <= 0:
		gameOver()

func gameOver():
	get_tree().paused = true
	updateHighscore()
	sfx_game_over()
	# buka scene/overlay game over
	pass
	
func updateHighscore():
	pass

func sfx_game_over():
	pass