extends Enemy


func _on_shield_node_area_entered(area: Area2D) -> void:
	if area is FriendlyWeapon:
		area.queue_free()
