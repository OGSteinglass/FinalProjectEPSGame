extends Node2D
enum State {Black, White, Empty, FlippingBlack, FlippingWhite}
var curstate = State.Empty

func switch_to(state):
	curstate = state
	if state == State.Black:
		$AnimatedSprite2D.play("black")
	elif state == State.Empty:
		$AnimatedSprite2D.play("empty")
	elif state == State.White:
		$AnimatedSprite2D.play("white")
	elif state == State.FlippingBlack:
		$AnimatedSprite2D.play("flip")
	elif state == State.FlippingWhite:
		$AnimatedSprite2D.play_backwards("flip")

func _ready():
	switch_to(State.Empty)


func _on_animated_sprite_2d_animation_finished():
	if curstate == State.FlippingWhite:
		switch_to(State.White)
	elif curstate == State.FlippingBlack:
		switch_to(State.Black)
