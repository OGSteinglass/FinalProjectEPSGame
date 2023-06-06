extends AudioStreamPlayer2D
func _ready():
	volume_db = 0+ 20*log(Globals.master_volume)+20*log(Globals.music_volume)
