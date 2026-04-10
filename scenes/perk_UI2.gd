extends Control

@export var background:TextureRect
@export var icon:TextureRect
@export var idLabel:Label
@export var cdLabel:Label

func _on_player_obtain_skill(ID: String, path: String, slot: int) -> void:
	slot+=1
	var slotName = "Perk"+str(slot)
	print_debug(slotName)
	if name == slotName:
		idLabel.text = ID
		icon.texture = load(path)
		show()
		cdLabel.hide()
		#print_debug(slotName, path, ID)

func _on_player_go_on_cooldown(id:String) -> void:
	if idLabel.text == id:
		if id == "ZAWARUDO":
			process_mode = Node.PROCESS_MODE_INHERIT
		if id == "revive":
			idLabel.text = ""
			hide()
		else:
			cdLabel.show()
			background.texture = load("res://assets/perk_sprites/perk UI cd.png")

func _on_player_go_off_cooldown(id:String) -> void:
	if idLabel.text == id:
		cdLabel.hide()
		background.texture = load("res://assets/perk_sprites/perk UI neutral.png")

func _on_player_while_activated(id:String) -> void:
	if idLabel.text == id:
		if id == "ZAWARUDO":
			process_mode = Node.PROCESS_MODE_ALWAYS
		background.texture = load("res://assets/perk_sprites/perk UI active.png")

func _on_player_update_perk_cd_label(id: String, cd: String) -> void:
	if idLabel.text == id:
		cdLabel.text = cd
