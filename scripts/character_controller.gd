extends CharacterBody2D
class_name Player

#@export var charVis:Sprite2D
@onready var shoot_sound = $ShootSound #Sound tembak
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
var recastCounter:int = 0
var dur:Array = []
var activated:Array = []
var isSpinning:bool = false
#var isRecast:bool = false
var timeStopped:bool = false

signal get_hurt(lost_health: float)
signal obtain_skill(ID:String, path:String, slot:int)
signal while_activated(id:String)
signal go_on_cooldown(id:String)
signal go_off_cooldown(id:String)
signal update_perk_cd_label(id:String, cd:String)
signal on_timestop(state:bool)

var rifle_sound = preload("res://assets/sound/laserShoot1.wav")
var sniper_sound = preload("res://assets/sound/laserShoot2.wav")
var shotgun_sound = preload("res://assets/sound/laserShoot3.wav")

func _ready() -> void:
	setup(SelectionInstructions.playerData)
	on_timestop.connect(_on_time_stopped)
	SelectionInstructions.on_bonus_select.connect(_on_bonus_recived)
	SelectionInstructions.phoenix_consume.connect(_on_revive_consumed)

func setup(data:Dictionary):
	$AnimatedSprite2D.play()

	match data["type"]:
		0:
			weapon = load("res://scenes/weapons/" + data["ID"] + ".tscn")
			weaponType = data["ID"]
			selectShootSound()
			var initial:FriendlyWeapon = weapon.instantiate()
			add_child(initial)
			initial.setup(weaponType, muzzle.position, timeStopped)
			fireRate = initial.fireRate
			initial.queue_free()
		1:
			if perks.has("empty"):
				insertPerks(perks.find("empty"), data)
			else:
				perks.append(data["ID"])
				baseCDs.append(data["CDs"])
				cooldowns.append(0)
				dur.append(0)
				activated.append(0)
			obtain_skill.emit(data["ID"], 
				Select.perkIcons[Select.perks.find(data["ID"])], 
				perks.find(data["ID"])
			)
			if data["ID"] == "revive":
				var idx = perks.find("revive")
				perk.UsePerk("revive", idx)
				activated[idx] = 1
			SelectionInstructions.playerPerks.append(data["ID"])
		2:
			upgrades.append(data["ID"])
			SelectionInstructions.dmgMulti = (0.8 * upgrades.count("damage"))
			SelectionInstructions.fireRateUp = (0.004 * upgrades.count("HF"))
			SelectionInstructions.recast = upgrades.count("double")
			if upgrades.has("throwable") and SelectionInstructions.throw == false:
				SelectionInstructions.throw = true
			if upgrades.has("metal pipe") and SelectionInstructions.pipe == false:
				SelectionInstructions.pipe = true
				shoot_sound.stream = load("res://assets/sound/pipe.wav")

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
		if fire and not isSpinning:
			summonWeaponSawblade()
	elif fire and count >= fireRate:
		#print_debug(SelectionInstructions.recast)
		if recastCounter < SelectionInstructions.recast and weaponType != "explosive":
			summonWeapon()
			recastCounter+=1
			if recastCounter == SelectionInstructions.recast:
				count = 0
		else:
			count = 0
			recastCounter = 0
			summonWeapon()
	
	moveChar(xMove, yMove)

func castPerks():
	if perk1 and len(perks) > 0 and cooldowns[0] <= 0 and activated[0] == 0:
		perk.UsePerk(perks[0], 0)
		cooldowns[0] = baseCDs[0]
		activated[0] = 1
	if perk2 and len(perks) > 1 and cooldowns[1] <= 0 and activated[1] == 0:
		perk.UsePerk(perks[1], 1)
		cooldowns[1] = baseCDs[1]
		activated[1] = 1
	if perk3 and len(perks) > 2 and cooldowns[2] <= 0 and activated[2] == 0:
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
		elif activated[a] == 1 and perks[a] != "revive":
			if d < 0:
				dur[a] = 0
			perk.StopPerk(perks[a], a)
			go_on_cooldown.emit(perks[a])
			update_perk_cd_label.emit(perks[a], "%.1f" % cooldowns[a])
		a+=1
	for c in cooldowns:
		if c > 0 and dur[a2] <= 0:
			cooldowns[a2] -= delta
			if cooldowns[a2] <= 0:
				update_perk_cd_label.emit(perks[a2], "0")
				go_off_cooldown.emit(perks[a2])
			else:
				update_perk_cd_label.emit(perks[a2], "%.1f" % cooldowns[a2])
		a2+=1

func summonWeapon():
	if weaponType == "shotgun":
		#count = 0
		var bulletCount = 6
		var spread = 0.3
		for i in bulletCount:
			var bullet:FriendlyWeapon = weapon.instantiate()
			get_parent().add_child(bullet)
			bullet.setup(weaponType, global_position, timeStopped)
			on_timestop.connect(bullet._on_timeStop)
			bullet.rotation_degrees = -45
			var angleOffset = lerp(-spread, spread, float(i) / (bulletCount - 1))
			bullet.rotation = rotation + angleOffset
			
		shoot_sound.play()
	else:
		#count = 0
		shoot_sound.play()
		var bullet:FriendlyWeapon = weapon.instantiate()
		if FriendlyWeapon.meleeWeapons.has(weaponType):
			add_child(bullet)
			bullet.setup(weaponType, muzzle.position, timeStopped)
		else:
			get_parent().add_child(bullet)
			bullet.setup(weaponType, global_position, timeStopped)
		on_timestop.connect(bullet._on_timeStop)
		

func summonWeaponSawblade():
	var sawblade:FriendlyWeapon = weapon.instantiate()
	add_child(sawblade)
	sawblade.setup(weaponType, muzzle.position, timeStopped)
	on_timestop.connect(sawblade._on_timeStop)
	sawblade.sawblade_off.connect(_on_saw_deactivation)
	isSpinning = true

func moveChar(xMove:float, yMove:float):
	velocity.y = yMove
	
	if xMove: #apply horizontal movement
		velocity.x = xMove
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
	
	move_and_slide() #move
			
func selectShootSound(): #Fungsi sound tembak
	pass
func play_shoot_sound(): #fungsi sound
	match weaponType:
		"rifle":
			shoot_sound.stream = rifle_sound
		"sniper":
			shoot_sound.stream = sniper_sound
		"shotgun":
			shoot_sound.stream = shotgun_sound
		_:
			return # kalau weapon lain gak ada sound
	
	shoot_sound.pitch_scale = randf_range(0.95, 1.05)
	shoot_sound.play()

func insertPerks(idx:int, data:Dictionary):
	perks[idx] = (data["ID"])
	baseCDs[idx] = (data["CDs"])
	cooldowns[idx] = (0)
	dur[idx] = (0)
	activated[idx] = (0)

func rearrangePerks(arr:Array, idx:int):
	arr.erase("revive")
	if len(arr) == 3:
		if idx == 1:
			arr.append("a")
			arr[2] = arr[1]
			if idx == 0:
				arr[1] = arr[0]
			arr[idx] = "empty"
	return arr

func _on_saw_deactivation():
	isSpinning = false

func _on_bonus_recived():
	setup(SelectionInstructions.playerData)

func _on_revive_consumed():
	go_on_cooldown.emit("revive")
	var index = perks.find("revive")
	perk.StopPerk("revive", index)
	perks = rearrangePerks(perks, index)
	baseCDs = rearrangePerks(baseCDs, index)
	cooldowns = rearrangePerks(cooldowns, index)
	dur = rearrangePerks(dur, index)
	activated = rearrangePerks(activated, index)
	SelectionInstructions.playerPerks = rearrangePerks(SelectionInstructions.playerPerks, index)
	
	#rearrangePerks()

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area is EnemyProjectile:
		get_hurt.emit(area.damage)

func _on_time_stopped(state:bool):
	if state == true:
		timeStopped = true
	else:
		timeStopped = false
