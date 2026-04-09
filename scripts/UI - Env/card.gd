extends TextureButton

@onready var itemName:Label = $Title
@onready var itemDesc:Label = $Description
@onready var itemIcon:TextureRect = $Icon

func setup(title:String, icon:String, type:int):
	if type == 0:
		texture_normal = load("res://assets/selection_screen/bg off.png")
		texture_pressed = load("res://assets/selection_screen/bg off.png")
		texture_hover = load("res://assets/selection_screen/bg.png")
	else:
		texture_normal = load("res://assets/selection_screen/perk&upgrade bg off.png")
		texture_pressed = load("res://assets/selection_screen/perk&upgrade bg off.png")
		texture_hover = load("res://assets/selection_screen/perk&upgrade bg.png")
	itemName.text = title
	itemIcon.texture = load(icon)
	itemDesc.visible = false
