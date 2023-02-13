extends Node2D

func _ready():
	var player2Texture = preload("res://assets/blue_car.png")
	get_node("TrackOne/Player/Car2/Sprite").set_texture(player2Texture)

	get_node("TrackOne").pause_mode = PAUSE_MODE_STOP;
	print(get_node("TrackOne/Player").pause_mode)

func prepare_race():
	get_node("Music").play()
	get_node("StartButton").hide()
	get_node("StartTimer").start()



func start_race():
	get_node("TrackOne").pause_mode = PAUSE_MODE_INHERIT;
