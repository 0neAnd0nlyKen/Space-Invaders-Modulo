extends Control

#@export var card: = preload("res://scenes/card.tscn")
#@export var player: = preload("res://scenes/player.tscn")
@onready var bg:ColorRect = $Background
@onready var nextButton:BaseButton = $Next_Button
@onready var menuText:Label = $Title
@onready var C1:TextureButton = $Card1
@onready var C2:TextureButton = $Card2
@onready var C3:TextureButton = $Card3

var picked:bool
var nextScene:String
var selected:Array = []
var selectedIcons:Array = []
var selectedCDs:Array = []
const weapons:Array = ["rifle", "sniper", "shotgun", "explosive", "sword", "saw", "repulsar"]
const perks:Array = ["shield", "sprint", "ZAWARUDO", "repair", "revive"]
const upgrades:Array = ["damage", "HF", "throwable", "double", "metal pipe"]
const weaponIcons:Array = [
	"res://assets/weapon sprites/rifle.png", "res://assets/weapon sprites/railgun.png",
	"res://assets/weapon sprites/shotgun.png", "res://assets/weapon sprites/explosive.png",
	"res://assets/weapon sprites/sword.png", "res://assets/weapon sprites/saw.png",
	"res://assets/weapon sprites/repulsar.png"
	]
const perkIcons:Array = ["res://assets/perk_sprites/shield.png", "res://assets/perk_sprites/sprint.png", 
	"res://assets/perk_sprites/ZAWARUDO.png", "res://assets/perk_sprites/repair.png", 
	"res://assets/perk_sprites/revive.png"
	]
const upgradeIcons:Array = ["res://assets/upgrade_sprites/damage.png", "res://assets/upgrade_sprites/HF.png",
	"res://assets/upgrade_sprites/throwable.png", "res://assets/upgrade_sprites/recast.png",
	"res://assets/upgrade_sprites/pipe.png"]
const perkCDs:Array = [8.0, 3.0, 20.0, 8.0, 0.0]

func _ready() -> void:
	setup(SelectionInstructions.data)

func setup(instructions:Dictionary) -> void:
	nextScene = "res://scenes/" + instructions["next"] + ".tscn"
	menuText.text = instructions["title"]
	nextButton.disabled = true
	if instructions["type"] != 1:
		bg.modulate.a = 0.6
	match instructions["type"]:
		0:
			while selected.size() < 3:
				var pick = weapons.pick_random()
				if pick not in selected:
					var index = weapons.find(pick)
					selected.append(pick)
					selectedCDs.append(0)
					selectedIcons.append(weaponIcons[index])
		1:
			while selected.size() < 3:
				var pick = perks.pick_random()
				if pick not in selected and pick not in SelectionInstructions.playerPerks:
					var index = perks.find(pick)
					selected.append(pick)
					selectedCDs.append(perkCDs[index])
					selectedIcons.append(perkIcons[index])
		2:
			while selected.size() < 3:
				var pick = upgrades.pick_random()
				if pick not in selected:
					var index = upgrades.find(pick)
					selected.append(pick)
					selectedCDs.append(0)
					selectedIcons.append(upgradeIcons[index])
	
	C1.setup(selected[0], selectedIcons[0])
	C2.setup(selected[1], selectedIcons[1])
	C3.setup(selected[2], selectedIcons[2])
	

func _process(_delta: float) -> void:
	if picked:
		nextButton.disabled = false

func FillData(itemID:String, cd:float):
	SelectionInstructions.playerData = {}
	SelectionInstructions.playerData = {
		"type": SelectionInstructions.data["type"],
		"ID": itemID,
		"CDs": cd
	}

func _on_card_1_pressed() -> void:
	FillData(selected[0], selectedCDs[0])
	picked = true

func _on_card_2_pressed() -> void:
	FillData(selected[1], selectedCDs[1])
	picked = true

func _on_card_3_pressed() -> void:
	FillData(selected[2], selectedCDs[2])
	picked = true

func _on_next_button_pressed() -> void:
	if SelectionInstructions.data["type"] == 0:
		get_tree().change_scene_to_file(nextScene)
	else:
		get_tree().paused = false
		SelectionInstructions.on_bonus_select.emit()
		queue_free()
