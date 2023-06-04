extends HSlider


func _on_value_changed(value):
	Globals.master_volume = value
