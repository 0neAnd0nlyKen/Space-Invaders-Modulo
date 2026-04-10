extends Node2D
class_name World

@export var score: int = 0
@export var health: int = 9
@export var healthLabel: Label
@export var scoreLabel: Label
@export var spawnerNode: Node2D
@export var p1:Control
@export var p2:Control
@export var p3:Control

var difficulty_level: int = 0 
var next_difficulty_score: int = 100
var selectionOverlayLayer
var bonusTaken:int = 0
var perksTaken:int = 0
var maxHealth: int = 30
var shield = preload("res://scenes/shield.tscn")
var shieldExists:bool = false
var reviveAvailable:bool = false

signal take_damage(amount:int)

func _ready() -> void:
	health = maxHealth
	selectionOverlayLayer = CanvasLayer.new()
	SelectionInstructions.repair_perk.connect(_on_repair_recived)
	SelectionInstructions.shield_create.connect(_on_shield_recived)
	SelectionInstructions.shield_destroy.connect(_on_shield_destroyed)
	SelectionInstructions.phoenix_init.connect(_on_phoenix_recive)
	SelectionInstructions.phoenix_consume.connect(_on_phoenix_consume)
	BGM.play_music("res://assets/sound/Gameplay.mp3")
	BGM.bgm_player.volume_db = -15
	updateLabel(healthLabel, health)
	updateLabel(scoreLabel, score)
	p1.hide()
	p2.hide()
	p3.hide()

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
	print("detected death")
	if score >= 1200 + (bonusTaken*1200):
		var bonusType
		var selectionText
		if perksTaken < 3:
			bonusType = 1
			selectionText = "Choose Perk"
			perksTaken += 1
		else:
			bonusType = 2
			selectionText = "Choose Upgrade"
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

func _on_phoenix_recive():
	reviveAvailable = true
func _on_phoenix_consume():
	health = maxHealth
	reviveAvailable = false
	perksTaken -= 1
	updateLabel(healthLabel, health)

func _on_repair_recived(amount:int):
	print_debug("work bitch", amount, " ", health, " ", maxHealth)
	health = (health + amount)
	#if health < maxHealth:
		#health = maxHealth
	updateLabel(healthLabel, health)

func _on_enemy_landed(enemyHealth: float): #hardcoded newEnemy.(signal).connect in spawner node
	print_debug("enemy landed ", enemyHealth )
	lose_health(enemyHealth)

func _on_player_get_hurt(lost_health: float) -> void:
	lose_health(lost_health)

func lose_health(lost_health: float):
	if shieldExists:
		take_damage.emit(lost_health)
	else:
		health -= int(lost_health)
	updateLabel(healthLabel, health)
	if health <= 0:
		if reviveAvailable:
			SelectionInstructions.phoenix_consume.emit()
		else:
			gameOver()

func gameOver():
	#get_tree().paused = true
	SelectionInstructions.playerDetail["score"] = score
	save_score(SelectionInstructions.playerDetail["name"], SelectionInstructions.playerDetail["score"])
	get_tree().change_scene_to_file("res://scenes/game_over.tscn")
	
func save_score(playerName: String, score: int) -> void:
	var scores = load_scores()
	scores.append({"name": playerName, "score": score})
	scores.sort_custom(func(a, b): return a["score"] > b["score"])  # sort high to low
	
	var file = FileAccess.open("user://scores.json", FileAccess.WRITE)
	file.store_string(JSON.stringify(scores))
	file.close()

func load_scores() -> Array:
	if not FileAccess.file_exists("user://scores.json"):
		return []
		
	var file = FileAccess.open("user://scores.json", FileAccess.READ)
	var data = JSON.parse_string(file.get_as_text())
	file.close()
	return data if data != null else []
