extends HSlider

func _ready():
	value = Globals.music_volume
	


func _on_value_changed(value):
	Globals.music_volume = value
