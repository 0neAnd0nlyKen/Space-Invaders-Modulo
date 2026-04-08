extends CharacterBody2D
@onready var shoot_sound = $ShootSound #Sound tembak

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

var rifle_sound = preload("res://assets/sound/laserShoot1.wav")
var sniper_sound = preload("res://assets/sound/laserShoot2.wav")
var shotgun_sound = preload("res://assets/sound/laserShoot3.wav")

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
		play_shoot_sound()
		var bullet:FriendlyWeapon = weapon.instantiate()
		add_child(bullet)
		fireRate = bullet.fireRate
		bullet.gunType = weaponType
		bullet.position = muzzle.position
	
	if xMove: #apply horizontal movement
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
			
func play_shoot_sound(): #Fungsi sound tembak
	match weaponType:
		0:
			shoot_sound.stream = rifle_sound
		1:
			shoot_sound.stream = sniper_sound
		2:
			shoot_sound.stream = shotgun_sound
	
	shoot_sound.play()
	
		
