extends Node2D
class_name World
@export var score: int = 0
@export var scoreLabel: Label

func _ready() -> void:
	updateLabel(scoreLabel, score)

func updateLabel(label: Label, num: int):
	label.text = str(num)

func _on_enemy_defeated(enemyScore: int):
	score += enemyScore
	updateLabel(scoreLabel, score)
	print("detected death")
