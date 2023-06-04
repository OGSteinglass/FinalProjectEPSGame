extends HSlider


func _on_value_changed(value):
	if value == 0:
		Globals.difficulty="easy"
	elif value ==1:
		Globals.difficulty="medium"
	elif value ==2:
		Globals.difficulty="hard"
