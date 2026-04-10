extends Enemy

@export var shieldNode: Area2D
@export var shieldCol: CollisionShape2D
@export var shieldSprite: Sprite2D
func _ready() -> void:
	setup_shield()
	# Override defaults for heavy enemy
	max_health = 40
	health = max_health
	enemy_score = 250
	base_speed = 15  # Slower
	super()

func move_enemy(_delta: float) -> void:
	# Heavy enemies move straight down but slower
	velocity.y = base_speed

func setup_shield():
	var viewport_rect = get_viewport_rect()
	var screen_width = viewport_rect.size.x
	
	var shield_width = screen_width
	var shield_height = 16
	
	# Set collision shape size
	if shieldCol.shape is RectangleShape2D:
		shieldCol.shape.size = Vector2(shield_width, shield_height)
	
	# Set sprite size to match
	if shieldSprite.texture:
		var texture_size = shieldSprite.texture.get_size()
		shieldSprite.scale = Vector2(shield_width / texture_size.x, shield_height / texture_size.y)
	
	#shieldNode.global_position.x = screen_width
	shieldNode.global_position.x = 0


func _on_shield_node_area_entered(area: Area2D) -> void:
	if area is FriendlyWeapon:
		print("area damage before: ", area.damage)
		area.damage *= 0.7
		print("area damage after: ", area.damage)
