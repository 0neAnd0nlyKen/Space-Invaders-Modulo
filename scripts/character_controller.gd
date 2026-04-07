extends CharacterBody2D

#@export var charVis:Sprite2D
@export var muzzle:Node2D
@export var speed:float = 300
@export var weaponType:int
var weapon
var move:Vector2
var moveDir
var fire
var fireRate:float = 0.5
var count:float = 0

func _ready() -> void:
	pass
	#if charVis == null:
		#charVis = $Sprite2D
	
func _physics_process(delta: float) -> void:
	count += delta
	get_input()
	CheckGunType()
	var xMove:float = moveDir * speed
	
	if fire and count >= fireRate:
		count = 0
		var bullet:FriendlyWeapon = weapon.instantiate()
		add_child(bullet)
		sfx_fire_weapon()
		fireRate = bullet.fireRate
		bullet.gunType = weaponType
		bullet.position = muzzle.position
	
	if xMove: #apply horizontal movement
		sfx_move_player()
		velocity.x = xMove
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
	
	move_and_slide() #move
	

func get_input():
	moveDir = Input.get_axis("left", "right")
	fire = Input.is_action_pressed("fire")
	if Input.is_action_just_pressed("weapon 1"):
		weaponType = 0
	elif Input.is_action_just_pressed("weapon 2"):
		weaponType = 1
	elif Input.is_action_just_pressed("weapon 3"):
		weaponType = 2

func CheckGunType():
	match weaponType:
		0:
			weapon = load("res://scenes/rifle.tscn")
		1:
			weapon = load("res://scenes/sniper.tscn")
		2:
			weapon = load("res://scenes/shotgun.tscn")

func sfx_fire_weapon(): # player tembak
	pass

funx sfx_move_player(): # player gerak kiri/kanan
	pass