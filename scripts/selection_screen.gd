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
var weapons:Array = ["rifle", "sniper", "shotgun", "explosive", "sword", "saw", "repulser"]
var perks:Array = ["shield", "sprint", "rewind", "ZAWARUDO", "repair", "summon", "revive"]
var upgrades:Array = ["damage", "HF", "shrapnel", "throwable", "inversion", "OHE", "DOT"]

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
					selected.append(pick)
		1:
			while selected.size() < 3:
				var pick = perks.pick_random()
				if pick not in selected:
					selected.append(pick)
		2:
			while selected.size() < 3:
				var pick = upgrades.pick_random()
				if pick not in selected:
					selected.append(pick)

func _process(_delta: float) -> void:
	if picked:
		nextButton.disabled = false

func _on_card_1_pressed() -> void:
	picked = true

func _on_card_2_pressed() -> void:
	picked = true

func _on_card_3_pressed() -> void:
	picked = true

func _on_next_button_pressed() -> void:
	get_tree().change_scene_to_file(nextScene)
