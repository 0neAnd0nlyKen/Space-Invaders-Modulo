extends Node2D

func UsePerk(perkName:String, slot:int):
	match perkName:
		"shield":
			pass
		"sprint":
			var parent = get_parent()
			parent.dur[slot] = 4.0
			parent.speed = 450
		"ZAWARUDO":
			var parent = get_parent()
			parent.dur[slot] = 7.0
			parent.process_mode = Node.PROCESS_MODE_ALWAYS
		"repair":
			pass
		"revive":
			pass

func StopPerk(perkName:String):
	match perkName:
		"shield":
			pass
		"sprint":
			var parent = get_parent()
			parent.speed = 300
		"ZAWARUDO":
			var parent = get_parent()
			parent.process_mode = Node.PROCESS_MODE_INHERIT
		"repair":
			pass
		"revive":
			pass
