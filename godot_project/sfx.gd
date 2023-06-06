extends HSlider

func _ready():
	value = Globals.sfx_volume



func _on_value_changed(value):
	Globals.sfx_volume=value
