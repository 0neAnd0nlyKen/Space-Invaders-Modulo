extends Control

#@export var card: = preload("res://scenes/card.tscn")
@export var player: = preload("res://scenes/player.tscn")
@onready var nextButton:BaseButton = $Next_Button
@onready var menuText:Label = $Title
@onready var C1:TextureButton = $Card1
@onready var C2:TextureButton = $Card2
@onready var C3:TextureButton = $Card3
var picked:bool
var nextScene:String
var selected:Array = []
var selectedIcons:Array = []
var weapons:Array = ["rifle", "sniper", "shotgun", "explosive", "sword", "saw", "repulsar"]
var perks:Array = ["shield", "sprint", "rewind", "ZAWARUDO", "repair", "summon", "revive"]
var upgrades:Array = ["damage", "HF", "shrapnel", "throwable", "inversion", "OHE", "DOT"]
var icons:Array = [
	"res://assets/weapon sprites/rifle.png", "res://assets/weapon sprites/railgun.png",
	"res://assets/weapon sprites/shotgun.png", "res://assets/weapon sprites/explosive.png",
	"res://assets/weapon sprites/sword.png", "res://assets/weapon sprites/saw.png",
	"res://assets/weapon sprites/repulsar.png"
	]

func _ready() -> void:
	setup(SelectionInstructions.data)

func setup(instructions:Dictionary) -> void:
	nextScene = "res://scenes/" + instructions["next"] + ".tscn"
	menuText.text = instructions["title"]
	nextButton.disabled = true
	match instructions["type"]:
		0:
			while selected.size() < 3:
				var pick = weapons.pick_random()
				if pick not in selected:
					var index = weapons.find(pick)
					selected.append(pick)
					selectedIcons.append(icons[index])
		1:
			while selected.size() < 3:
				var pick = perks.pick_random()
				if pick not in selected:
					var index = weapons.find(pick)
					selected.append(pick)
					selectedIcons.append(icons[index])
		2:
			while selected.size() < 3:
				var pick = upgrades.pick_random()
				if pick not in selected:
					var index = weapons.find(pick)
					selected.append(pick)
					selectedIcons.append(icons[index])
	
	C1.setup(selected[0], selectedIcons[0])
	C2.setup(selected[1], selectedIcons[1])
	C3.setup(selected[2], selectedIcons[2])

func _process(_delta: float) -> void:
	if picked:
		nextButton.disabled = false

func _on_card_1_pressed() -> void:
	sfx_weapon_picked()
	picked = true

func _on_card_2_pressed() -> void:
	sfx_weapon_picked()
	picked = true

func _on_card_3_pressed() -> void:
	sfx_weapon_picked()
	picked = true

func _on_next_button_pressed() -> void:
	get_tree().change_scene_to_file(nextScene)

func sfx_weapon_picked(): #memilih satu senjata
	pass