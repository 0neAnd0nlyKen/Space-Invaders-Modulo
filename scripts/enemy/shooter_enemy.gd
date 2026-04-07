extends Enemy
class_name ShooterEnemy

# Enemy that shoots down projectiles

@export var shoot_rate: float = 1.5
@export var shoot_offset: Vector2 = Vector2(0, 20)

var shoot_timer: float = 0.0

func _ready() -> void:
	max_health = 25
	health = max_health
	enemy_score = 150
	base_speed = 25
	super()

func move_enemy(_delta: float) -> void:
	velocity.y = base_speed

func _process(delta: float) -> void:
	time_alive += delta
	move_enemy(delta)
	move_and_slide()
	
	# Shooting logic
	shoot_timer += delta
	if shoot_timer >= shoot_rate:
		shoot_timer = 0.0
		shoot()

func shoot() -> void:
	# Create a simple projectile Area2D
	var projectile = Area2D.new()
	projectile.name = "EnemyProjectile"
	
	# Add collision shape
	var shape = CollisionShape2D.new()
	shape.shape = CircleShape2D.new()
	shape.shape.radius = 3
	projectile.add_child(shape)
	
	# Create visual representation (sprite)
	var sprite = ColorRect.new()
	sprite.size = Vector2(6, 6)
	sprite.color = Color.RED
	projectile.add_child(sprite)
	
	get_parent().add_child(projectile)
	projectile.position = global_position + shoot_offset
	
	# Add custom velocity property
	projectile.set_meta("velocity", Vector2(0, 200))
	projectile.set_meta("damage", 5)
