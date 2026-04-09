extends Node

var data:Dictionary = {}
var playerData:Dictionary = {}
var playerPerks:Array = []

var dmgMulti:float
var fireRateUp:float
var recast:int
var pipe:bool = false
var throw:bool = false

signal on_bonus_select()
signal repair_perk(amount:int)
signal shield_create(durability:int)
signal shield_destroy()
signal phoenix_init()
signal phoenix_consume()
