extends Node2D

func UsePerk(perkName:String, slot:int):
	var parent = get_parent()
	match perkName:
		"shield":
			parent.dur[slot] = 10.0
			parent.while_activated.emit(perkName)
			SelectionInstructions.shield_create.emit(6)
		"sprint":
			parent.dur[slot] = 4.0
			parent.while_activated.emit(perkName)
			parent.speed = 450
		"ZAWARUDO":
			parent.dur[slot] = 7.0
			parent.process_mode = Node.PROCESS_MODE_ALWAYS
			parent.physics_interpolation_mode = Node.PHYSICS_INTERPOLATION_MODE_ON
			process_mode = Node.PROCESS_MODE_ALWAYS
			parent.while_activated.emit(perkName)
			get_tree().paused = true
		"repair":
			parent.dur[slot] = 0.1
			parent.while_activated.emit(perkName)
			SelectionInstructions.repair_perk.emit(3)
		"revive":
			parent.while_activated.emit(perkName)
			SelectionInstructions.phoenix_init.emit()

func StopPerk(perkName:String, slot:int):
	var parent = get_parent()
	match perkName:
		"shield":
			SelectionInstructions.shield_destroy.emit()
			parent.activated[slot] = 0
		"sprint":
			parent.speed = 300
			parent.activated[slot] = 0
		"ZAWARUDO":
			get_tree().paused = false
			parent.activated[slot] = 0
			parent.process_mode = Node.PROCESS_MODE_INHERIT
			process_mode = Node.PROCESS_MODE_INHERIT
		"repair":
			parent.activated[slot] = 0
		"revive":
			parent.activated[slot] = 0
