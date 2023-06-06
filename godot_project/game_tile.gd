extends Node2D
enum State {Black, White, Empty, FlippingBlack, FlippingWhite, Avalable}
var curstate = State.Empty
var DEFAULT_MODULATE = modulate
func switch_to(state):
	curstate = state
	if state == State.Black:
		$AnimatedSprite2D.play("black")
	elif state == State.Empty:
		$AnimatedSprite2D.play("empty")
	elif state == State.White:
		$AnimatedSprite2D.play("white")
	elif state == State.FlippingBlack:
		$AnimatedSprite2D.play("flip_black")
	elif state == State.FlippingWhite:
		$AnimatedSprite2D.play("flip_white")

func _ready():
	switch_to(State.Empty)


func _on_animated_sprite_2d_animation_finished():
	if curstate == State.FlippingWhite:
		switch_to(State.White)
	elif curstate == State.FlippingBlack:
		switch_to(State.Black)

func set_state(color):
	if color == 1:
		if curstate==State.Empty:
			switch_to(State.Black)
		elif curstate!=State.Black:
			switch_to(State.FlippingBlack)
	if color == 2:
		if curstate==State.Empty:
			switch_to(State.White)
		elif curstate!=State.White:
			switch_to(State.FlippingWhite)
		
	if color == 0:
		switch_to(State.Empty)
	
func make_avalable(yes):
	if yes:
		curstate=State.Avalable
		$AnimatedSprite2D.play("black")
		modulate = Color(1,1,1,0.5)
	if !yes:
		curstate=State.Empty
		$AnimatedSprite2D.play("empty")
		modulate = DEFAULT_MODULATE
