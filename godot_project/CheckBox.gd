extends CheckBox

func _ready():
	button_pressed=Globals.show_moves

func _on_toggled(button_pressed):
	Globals.show_moves = button_pressed
	
