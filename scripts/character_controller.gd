extends CharacterBody2D

#@export var charVis:Sprite2D
@onready var muzzle:Node2D = $muzzle
@onready var perk:Node2D = $perks
@export var speed:float = 300
@export var weaponType:String
@export var perks:Array = []
@export var upgrades:Array = []
@export var baseCDs:Array = []
var cooldowns:Array = []
var move:Vector2
var moveDir
var fire
var perk1
var perk2
var perk3
var weapon
var fireRate:float
var count:float = 0
var dur:Array = []
var spinned:bool = false

func _ready() -> void:
	setup(SelectionInstructions.playerData)
	SelectionInstructions.on_bonus_select.connect(_on_bonus_recived)

func setup(data:Dictionary):
	match data["type"]:
		0:
			weapon = load("res://scenes/weapons/" + data["ID"] + ".tscn")
			weaponType = data["ID"]
			var initial:FriendlyWeapon = weapon.instantiate()
			add_child(initial)
			initial.setup(weaponType, muzzle.position)
			fireRate = initial.fireRate
			initial.queue_free()
		1:
			perks.append(data["ID"])
			baseCDs.append(data["CDs"])
			cooldowns.append(0)
			dur.append(0)

func get_input():
	moveDir = Input.get_axis("left", "right")
	fire = Input.is_action_pressed("fire")
	perk1 = Input.is_action_just_pressed("perk 1")
	perk2 = Input.is_action_just_pressed("perk 2")
	perk3 = Input.is_action_just_pressed("perk 3")

func _physics_process(delta: float) -> void:
	count += delta
	get_input()
	var xMove:float = moveDir * speed
	
	get_cd_and_durs(delta)
	castPerks()
	
	if len(get_children()) < 4:
		spinned = false
	
	if weaponType == "saw":
		if fire and not spinned:
			summonWeaponSawblade()
	elif fire and count >= fireRate:
		summonWeapon()
	
	moveChar(xMove)

func castPerks():
	if perk1 and perks[0] != null and cooldowns[0] <= 0:
		perk.UsePerk(perks[0], 0)
		cooldowns[0] = baseCDs[0]
	if perk2 and perks[1] != null and cooldowns[1] <= 0:
		perk.UsePerk(perks[1], 1)
		cooldowns[1] = baseCDs[1]
	if perk3 and perks[2] != null and cooldowns[2] <= 0:
		perk.UsePerk(perks[2], 2)
		cooldowns[2] = baseCDs[2]

func get_cd_and_durs(delta:float):
	var a:int = 0
	var a2:int = 0
	for d in dur:
		if d > 0:
			d -= delta
		elif d <= 0:
			perk.StopPerk(perks[a])
			d = 0
		a+=1
	for c in cooldowns:
		if c > 0 and dur[a2] <= 0:
			c -= delta

func summonWeapon():
	count = 0
	var bullet:FriendlyWeapon = weapon.instantiate()
	add_child(bullet)
	bullet.setup(weaponType, muzzle.position)

func summonWeaponSawblade():
	var sawblade:FriendlyWeapon = weapon.instantiate()
	add_child(sawblade)
	sawblade.setup(weaponType, muzzle.position)
	spinned = true

func moveChar(xMove:float):
	if xMove:
		velocity.x = xMove
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
	
	move_and_slide() #move

func _on_bonus_recived():
	setup(SelectionInstructions.playerData)
