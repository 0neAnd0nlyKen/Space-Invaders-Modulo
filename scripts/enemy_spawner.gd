extends Node2D
class_name EnemySpawner

@export var spawnAnchor:Node2D
@export var maxEnemies: int = 10
@export var spawnRate: float = 2.0
@export var world: World

var spawnTimer: float = 0.0
var wave_counter: int = 0  # Track spawning waves for variety

func _ready() -> void:
	if spawnAnchor == null:
		spawnAnchor = $"../spawnpoint"

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
	# Vary enemy types based on wave or randomness
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
			if wave_counter > 3:  # Only spawn heavy after wave 3
				newEnemy = enemy_base.instantiate()
				newEnemy.set_script(preload("res://scripts/enemy/heavy_enemy.gd"))
			else:
				newEnemy = enemy_base.instantiate()
				newEnemy.set_script(preload("res://scripts/enemy/basic_enemy.gd"))
	add_child(newEnemy)
	newEnemy.position = spawn_point
	wave_counter += 1
	return newEnemy
