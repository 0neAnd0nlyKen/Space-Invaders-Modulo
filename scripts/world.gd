extends Node2D
class_name World

@export var score: int = 0
@export var health: int = 9
@export var healthLabel: Label
@export var scoreLabel: Label
var selectionOverlayLayer
var bonusTaken:int = 0
var maxHealth: int = 0
var shield = preload("res://scenes/shield.tscn")
var shieldExists:bool = false

signal take_damage(amount:int)

func _ready() -> void:
	selectionOverlayLayer = CanvasLayer.new()
	SelectionInstructions.repair_perk.connect(_on_repair_recived)
	SelectionInstructions.shield_create.connect(_on_shield_recived)
	SelectionInstructions.shield_destroy.connect(_on_shield_destroyed)
	updateLabel(healthLabel, health)
	updateLabel(scoreLabel, score)

func updateLabel(label: Label, num: int):
	label.text = str(num)

func _on_enemy_defeated(enemyScore: int):
	score += enemyScore
	updateLabel(scoreLabel, score)
	print("detected death")
	if score >= 1200 + (bonusTaken*1200):
		var bonusType
		var selectionText
		if bonusTaken >= 2:
			bonusType = 2
			selectionText = "Choose Upgrade"
		else:
			bonusType = 1
			selectionText = "Choose Perk"
		var selectionMenu = load("res://scenes/selection_screen.tscn")
		SelectionInstructions.data = {
			"type": bonusType,
			"next": "world",
			"title": selectionText
		}
		var menu = selectionMenu.instantiate()
		selectionOverlayLayer.add_child(menu)
		get_tree().root.add_child(selectionOverlayLayer)
		bonusTaken += 1
		get_tree().paused = true
		

func _on_shield_recived(shieldHealth:int):
	var newShield:ShieldPerk = shield.instantiate()
	add_child(newShield)
	newShield.health = shieldHealth
	take_damage.connect(newShield._on_taking_damage)
	shieldExists = true

func _on_shield_destroyed():
	shieldExists = false

func _on_repair_recived(amount:int):
	if health < maxHealth:
		if health+amount <= maxHealth:
			health += amount
		else:
			health = maxHealth

func _on_enemy_landed(enemyHealth: float):
	if shieldExists:
		take_damage.emit(enemyHealth)
	else:
		health -= int(enemyHealth)
		updateLabel(healthLabel, health)

func gameOver():
	get_tree().paused = true
	updateHighscore()
	# buka scene/overlay game over
	pass
	
func updateHighscore():
	pass
