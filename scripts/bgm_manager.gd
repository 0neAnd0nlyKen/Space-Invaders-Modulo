extends Node

var bgm_player: AudioStreamPlayer

func _ready():
	bgm_player = AudioStreamPlayer.new()
	add_child(bgm_player)
		

func play_music(path: String):
	if bgm_player.stream == load(path):
		return # lagu sama, jangan restart
	
	bgm_player.stop()
	bgm_player.stream = load(path)
	bgm_player.volume_db = -5
	bgm_player.play()
	
