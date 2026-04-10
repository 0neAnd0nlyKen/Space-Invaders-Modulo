extends Node2D
class_name EnemySpawner

@export var spawnAnchor:Node2D
@export var maxEnemies: int = 10
@export var spawnRate: float = 2.0
@export var world: World
@export var enemy_types: Array[EnemyType]


signal difficulty_increased()

var _spawn_pool: Array[EnemyType] = []
var spawnTimer: float = 0.0
var wave_counter: int = 0  # Track spawning waves for variety
var difficulty_level: int = 0


func _ready() -> void:
	if spawnAnchor == null:
		spawnAnchor = $"../spawnpoint"
	difficulty_increased.connect(_on_difficulty_increased)
	_build_weighted_spawn_pool()

func _build_weighted_spawn_pool():
	_spawn_pool.clear()
	for enemy_type in enemy_types:
		if enemy_type and enemy_type.scene:
			var weight = enemy_type.spawn_weight
			# Adjust weight based on difficulty
			if "heavy" in enemy_type.scene.resource_path and difficulty_level < 1:
				weight = 0
			elif "shooter" in enemy_type.scene.resource_path and difficulty_level < 2:
				weight = 0
			# Basic and wave always available
			if weight > 0:
				var count = max(1, int(weight * 10))
				for i in range(count):
					_spawn_pool.append(enemy_type)

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
				if world != null and world.has_method("_on_enemy_landed"):
					newEnemy.enemy_landed.connect(world._on_enemy_landed)

func spawn_enemy_variation(spawn_point: Vector2) -> Enemy:
	if _spawn_pool.is_empty():
		return null
	
	var selected_type = _spawn_pool[randi() % _spawn_pool.size()]
	selected_type = _spawn_pool[3]
	var newEnemy = selected_type.scene.instantiate()
	newEnemy.position = spawn_point
	add_child(newEnemy)
	return newEnemy


func _on_difficulty_increased() -> void:
	difficulty_level += 1
	spawnRate = max(0.5, spawnRate - 0.3)  # Make spawning more frequent
	maxEnemies += 1  # Allow more enemies on screen
	_build_weighted_spawn_pool()  # Update spawn pool with new difficulty
