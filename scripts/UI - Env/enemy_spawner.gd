extends Node2D
class_name EnemySpawner

@export var spawnAnchor:Node2D
@export var maxEnemies: int = 10
@export var spawnRate: float = 2.0
@export var world: World

signal difficulty_increased() # activated by world node

var spawnTimer: float = 0.0
var wave_counter: int = 0  # Track spawning waves for variety
var difficulty_level: int = 0

func _ready() -> void:
	if spawnAnchor == null:
		spawnAnchor = $"../spawnpoint"
	difficulty_increased.connect(_on_difficulty_increased)

func _process(delta: float) -> void:
	var spawnPoint:Vector2 = Vector2(randf_range(-400, 400), spawnAnchor.position.y)
	spawnTimer += delta
	
	if spawnTimer >= spawnRate:
		spawnTimer = 0.0
		if get_child_count() < maxEnemies:
			var newEnemy = spawn_enemy_variation(spawnPoint)
			if newEnemy:
				if world != null and world.has_method("_on_enemy_defeated"):
					newEnemy.enemy_defeated.connect(world._on_enemy_defeated)
					newEnemy.enemy_landed.connect(world._on_enemy_landed)

func spawn_enemy_variation(spawn_point: Vector2) -> Enemy:
	# Vary enemy types based on difficulty level
	var variation = randi() % 4  # 0=basic, 1=wave, 2=heavy, 3=shooter
	
	var newEnemy: Enemy
	var enemy_base = preload("res://scenes/enemy.tscn")
	
	match variation:
		0:
			# BasicEnemy
			newEnemy = enemy_base.instantiate()
			newEnemy.set_script(preload("res://scripts/enemy/basic_enemy.gd"))
		1:
			# WaveEnemy
			newEnemy = enemy_base.instantiate()
			newEnemy.set_script(preload("res://scripts/enemy/wave_enemy.gd"))
		2:
				newEnemy = enemy_base.instantiate()
				newEnemy.set_script(preload("res://scripts/enemy/heavy_enemy.gd"))
			else:
				newEnemy = enemy_base.instantiate()
				newEnemy.set_script(preload("res://scripts/enemy/basic_enemy.gd"))
		3:
			if wave_counter > 5:  # Only spawn shooters after wave 5
				newEnemy = enemy_base.instantiate()
				newEnemy.set_script(preload("res://scripts/enemy/shooter_enemy.gd"))
			else:
				newEnemy = enemy_base.instantiate()
				newEnemy.set_script(preload("res://scripts/enemy/basic_enemy.gd"))
	
	add_child(newEnemy)
	newEnemy.position = spawn_point
	wave_counter += 1
	return newEnemy
