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
var activated:Array = []
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
			activated.append(0)
			SelectionInstructions.playerPerks.append(data["ID"])
			print_debug(perks[-1], ": ", baseCDs[-1])

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
	var yMove:float = 0
	
	get_cd_and_durs(delta)
	castPerks()
	
	if weaponType == "saw":
		if get_child_count() == 4:
			spinned = false
		if fire and not spinned:
			summonWeaponSawblade()
	elif fire and count >= fireRate:
		summonWeapon()
	
	moveChar(xMove, yMove)

func castPerks():
	if perk1 and len(perks) > 0 and cooldowns[0] <= 0:
		perk.UsePerk(perks[0], 0)
		cooldowns[0] = baseCDs[0]
		activated[0] = 1
	if perk2 and len(perks) > 1 and cooldowns[1] <= 0:
		perk.UsePerk(perks[1], 1)
		cooldowns[1] = baseCDs[1]
		activated[1] = 1
	if perk3 and len(perks) > 2 and cooldowns[2] <= 0:
		perk.UsePerk(perks[2], 2)
		cooldowns[2] = baseCDs[2]
		activated[2] = 1

func get_cd_and_durs(delta:float):
	var a:int = 0
	var a2:int = 0
	for d in dur:
		if d > 0:
			dur[a] -= delta
			#print_debug("Duration ablility ", a, ":", d)
		elif d < 0:
			dur[a] = 0
			if activated[a] == 1:
				perk.StopPerk(perks[a], a)
		a+=1
	for c in cooldowns:
		if c > 0 and dur[a2] <= 0:
			cooldowns[a2] -= delta
			#print_debug("CD ablility ", a2, ":", c)
		a2+=1

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

func moveChar(xMove:float, yMove:float):
	velocity.y = yMove
	if xMove:
		velocity.x = xMove
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
	
	move_and_slide() #move

func _on_bonus_recived():
	setup(SelectionInstructions.playerData)
