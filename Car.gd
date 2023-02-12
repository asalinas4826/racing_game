extends KinematicBody2D

export var speed = 600
export var bounce = 2
var bouncing = false
var bounceVelocity = Vector2.ZERO

func _process(_delta):
	if bouncing && get_node("BounceTimer").is_stopped():
		get_node("BounceTimer").start()
		



func _on_Timer_timeout():
	bounceVelocity = Vector2.ZERO
	bouncing = false
