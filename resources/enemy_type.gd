class_name EnemyType
extends Resource

@export var scene: PackedScene :
	set(value):
		if value == null:
			scene = null
			return
			
		# Validate at assignment time (runtime & editor)
		if _is_valid_enemy_scene(value):
			scene = value
			# Optional: Cache the enemy class for faster access
			_cached_enemy_class = _get_enemy_class_name(value)
		else:
			printerr("[EnemyType] Invalid enemy scene: ", value.resource_path)
			scene = null

@export var spawn_weight: float = 1.0
@export var spawn_delay: float = 0.0
@export var custom_data: Dictionary = {}

# Cached data for performance
var _cached_enemy_class: String = ""

func _is_valid_enemy_scene(scene_to_check: PackedScene) -> bool:
	if not scene_to_check or not scene_to_check.can_instantiate():
		return false
	
	var instance = scene_to_check.instantiate()
	var is_valid = instance is Enemy
	instance.queue_free()
	return is_valid

func _get_enemy_class_name(scene_to_check: PackedScene) -> String:
	if not scene_to_check or not scene_to_check.can_instantiate():
		return ""
	
	var instance = scene_to_check.instantiate()
	var instance_class = instance.get_class()
	instance.queue_free()
	return instance_class

# Editor-only validation hint
func _validate_property(property: Dictionary):
	match property.name:
		"scene":
			# Add file type filtering in editor
			property.hint = PROPERTY_HINT_FILE
			property.hint_string = "*.tscn,*.scn"
		"spawn_weight":
			# Add range hint
			property.hint = PROPERTY_HINT_RANGE
			property.hint_string = "0.0,10.0,0.1"

# Helper method to instantiate safely
func instantiate_enemy() -> Enemy:
	if not scene:
		return null
	
	var instance = scene.instantiate()
	if instance is Enemy:
		return instance
	else:
		instance.queue_free()
		return null
