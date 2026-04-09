extends Enemy

@export var shieldNode: Area2D
@export var shieldCol: CollisionShape2D

func _ready() -> void:
	setup_shield()

func setup_shield():
	var viewport_rect = get_viewport_rect()
	var screen_width = viewport_rect.size.x
	
	shieldNode.position.x = screen_width / 2

	var collision_shape: RectangleShape2D = shieldCol.shape
	collision_shape.size.x = screen_width

	# Match Sprite2D size to CollisionShape2D
	var sprite: Sprite2D = $ShieldNode/Sprite2D
	if sprite:
		# Create a procedural texture for the shield
		var image = Image.create(int(collision_shape.size.x), int(collision_shape.size.y), false, Image.FORMAT_RGBA8)
		image.fill(Color(0, 1, 0, 0.5))  # Semi-transparent green shield
		
		var texture = ImageTexture.create_from_image(image)
		sprite.texture = texture
		
		# Reset scale since we're using the actual size
		sprite.scale = Vector2.ONE

func _on_shield_node_area_entered(area: Area2D) -> void:
	if area is FriendlyWeapon:
		print("area damage before: ", area.damage)
		area.damage *= 0.7
		print("area damage after: ", area.damage)
