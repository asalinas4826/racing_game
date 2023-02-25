extends KinematicBody2D

export var speed = 400
var bouncing = false
var bounceVelocity = Vector2.ZERO

var backwardsLap = true
var lapCount = 1
var playerTwo = false

func _process(_delta):
	if bouncing && get_node("BounceTimer").is_stopped():
		get_node("BounceTimer").start()
		



func _on_Timer_timeout():
	bounceVelocity = Vector2.ZERO
	bouncing = false


# Track vs. Race
# Does HUD depend on Track or Race?
# HUD will display laps, lap time

# audio?
# if music is different for every track, you'll want it to be in the track, but it's also synced w/ HUD
# sound effects should be in Player, actually

# using a race scene would also just be better organized and easier to look at, even if it's unnecessary

# start and end screens should be in race, as they should depend upon a higher-level game state
# if they were in track, then everything would have to be in track
