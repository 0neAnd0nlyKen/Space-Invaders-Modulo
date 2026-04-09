extends Node2D
class_name ShieldPerk
var health

func setup(health:int):
	pass

func _on_taking_damage(amount:int):
	health -=amount
	if health <= 0:
		SelectionInstructions.shield_destroy.emit()
