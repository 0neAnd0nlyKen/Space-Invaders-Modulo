extends CharacterBody2D
class_name Player
@onready var shoot_sound = $ShootSound #Sound tembak

#@export var charVis:Sprite2D
@export var muzzle:Node2D
@export var speed:float = 300
@export var weaponType:String
var move:Vector2
var moveDir
var weapon
var fire
var fireRate:float
var count:float = 0
var spinned:bool = false
signal get_hurt(lost_health: float)

var rifle_sound = preload("res://assets/sound/laserShoot1.wav")
var sniper_sound = preload("res://assets/sound/laserShoot2.wav")
var shotgun_sound = preload("res://assets/sound/laserShoot3.wav")

func _ready() -> void:
	setup(SelectionInstructions.playerData)

func setup(data:Dictionary):
	if data["type"] == 0:
		weapon = load("res://scenes/weapons/" + data["ID"] + ".tscn")
		weaponType = data["ID"]
		var initial:FriendlyWeapon = weapon.instantiate()
		add_child(initial)
		initial.setup(weaponType, muzzle.position)
		fireRate = initial.fireRate
		initial.queue_free()

func get_input():
	moveDir = Input.get_axis("left", "right")
	fire = Input.is_action_pressed("fire")

func _physics_process(delta: float) -> void:
	count += delta
	get_input()
	var xMove:float = moveDir * speed
	
	if len(get_children()) < 4:
		spinned = false
	
	if weaponType == "saw":
		if fire and not spinned:
			var sawblade:FriendlyWeapon = weapon.instantiate()
			add_child(sawblade)
			sawblade.setup(weaponType, muzzle.position)
			spinned = true
	
	elif fire and count >= fireRate:
		count = 0
		play_shoot_sound()
		var bullet:FriendlyWeapon = weapon.instantiate()
		add_child(bullet)
		bullet.setup(weaponType, muzzle.position)
	
	if xMove: #apply horizontal movement
		velocity.x = xMove
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
	
	move_and_slide() #move
	
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
	
		
