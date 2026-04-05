extends Node2D
class_name EnemySpawner

@export var spawnAnchor:Node2D
@export var enemy:  = preload("res://scenes/enemy.tscn")
@export var maxEnemies: int = 10
@export var spawnRate: float = 2.0
var spawnTimer: float = 0.0

func _ready() -> void:
	if spawnAnchor == null:
		spawnAnchor = $"../spawnpoint"

func _process(delta: float) -> void:
	var spawnPoint:Vector2 = Vector2(randf_range(-400, 400), spawnAnchor.position.y)
	spawnTimer += delta
	
	if spawnTimer >= spawnRate:
		spawnTimer = 0.0
		if get_child_count() < maxEnemies:
			var newEnemy: Enemy = enemy.instantiate()
			add_child(newEnemy)
			newEnemy.position = spawnPoint
	
