extends Node2D
class_name World
@export var score: int = 0
@export var health: int = 9
@export var healthLabel: Label
@export var scoreLabel: Label
@export var spawnerNode: Node2D

var difficulty_level: int = 0
var next_difficulty_score: int = 100

func _ready() -> void:
	updateLabel(healthLabel, health)
	updateLabel(scoreLabel, score)

func updateLabel(label: Label, num: int):
	label.text = str(num)
func is_difficulty_cleared() -> bool:
	return score >= next_difficulty_score


func _on_enemy_defeated(enemyScore: float): #hardcoded newEnemy.(signal).connect in spawner node
	score += int(enemyScore)
	if is_difficulty_cleared():
		spawnerNode.difficulty_increased.emit()
		next_difficulty_score += 100
	updateLabel(scoreLabel, score)

func _on_enemy_landed(enemyHealth: float): #hardcoded newEnemy.(signal).connect in spawner node
	print_debug("enemy landed ", enemyHealth )
	lose_health(enemyHealth)

func _on_player_get_hurt(lost_health: float) -> void:
	lose_health(lost_health)

func lose_health(lost_health: float):
	health -= int(lost_health)
	updateLabel(healthLabel, health)
	if health <= 0:
		gameOver()
	

func gameOver():
	get_tree().paused = true
	updateHighscore()
	# buka scene/overlay game over
	pass
	
func updateHighscore():
	pass
