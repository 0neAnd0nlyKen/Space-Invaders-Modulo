extends CharacterBody2D

#@export var charVis:Sprite2D
@export var muzzle:Node2D
@export var speed:float = 300
var move:Vector2
var moveDir
var fire
var fireRate:float = .2
var count:float = 0

func _ready() -> void:
	pass
	#if charVis == null:
		#charVis = $Sprite2D

func get_input():
	moveDir = Input.get_axis("left", "right")
	fire = Input.is_action_pressed("fire")
	
func _physics_process(delta: float) -> void:
	count += delta
	get_input()
	var xMove:float = moveDir * speed
	
	if xMove: #apply horizontal movement
		velocity.x = xMove
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
	
	move_and_slide() #move
	
