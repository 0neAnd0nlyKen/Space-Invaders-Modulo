extends Control

@onready var itemName:Label = $Title
@onready var itemDesc:Label = $Description
@onready var itemIcon:TextureRect = $Icon

func setup(title:String, icon:String):
	itemName.text = title
	itemIcon.texture = load(icon)
	itemDesc.visible = false
