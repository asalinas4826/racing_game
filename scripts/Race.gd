extends Node2D

var lapPos
var lapCount = 1

func _ready():
	var player2Texture = preload("res://assets/blue_car.png")
	get_node("TrackOne/Player/Car2/Sprite").set_texture(player2Texture)

	set_pause_scene(get_node("TrackOne"), 1)
	set_process(false)
	
	lapPos = get_node("TrackOne/LapCenter").position
	
	
func _process(_delta):
	fade_button_and_title()
	update_lap_angle(get_node("TrackOne/Player/Car"))
	
	
func fade_button_and_title():
	var button = get_node("HUD/StartButton")
	if button.modulate.a8 > 0:
		button.modulate.a8 -= 16
	
	var title = get_node("HUD/TrackTitle")
	if title.modulate.a8 > 0:	
		title.modulate.a8 -= 16


func prepare_race():
	get_node("Music").play()
	get_node("StartTimer").start()
	get_node("HUD/StartButton").disabled = true
	set_process(true)


func start_race():
	set_pause_scene(get_node("TrackOne"), 0)
	
	
func _on_exit_finish(body):
	if lapCount < 3 and body.lapAngle < 0.3:
		body.lapAngle = 2 * PI
		lapCount += 1
	print("\n" + str(lapCount) + "\n")
	
	
func _on_enter_finish(body):
	# do lap time here
	# end the game on 3rd lap
	
	# maybe do it so if you enter the finish line from the right and then leave it to the right it doesn't count?
	# like you have to enter from the left 1 more time than you exit from the right for it to count
	pass
	
	
func update_lap_angle(car): # lap is done when car is at < 0.2
	var lapVector = Vector2(lapPos.x - car.position.x, lapPos.y - car.position.y)
	var newAngle
	if lapVector.angle() >= 0 or lapVector.angle() < 0 and car.position.x < lapPos.x:
		newAngle = lapVector.angle() + PI / 2
	else:
		newAngle = lapVector.angle() + 5 * PI / 2
	
	if newAngle < car.lapAngle and car.lapAngle - newAngle < 0.2:
		car.lapAngle = newAngle
#	print(car.lapAngle)
	return car.lapAngle
	# exploit: angle is larger on inside of track so you could cheat a photo finish just by having
	# a teeny angle advantage. Solution: trigger the finish line as a collider in the last lap
	# collider turns on once the players reach a certain angle, and then they can win
	# so winning is NOT based on lap angle
	
	
#(Un)pauses a single node
func set_pause_node(node : Node, pause : bool) -> void:
	node.set_process(!pause)
	node.set_process_input(!pause)
	node.set_process_internal(!pause)
	node.set_process_unhandled_input(!pause)
	node.set_process_unhandled_key_input(!pause)


#(Un)pauses a scene
#Ignored childs is an optional argument, that contains the path of nodes whose state must not be altered by the function
func set_pause_scene(rootNode : Node, pause : bool, ignoredChilds : PoolStringArray = [null]):
	set_pause_node(rootNode, pause)
	for node in rootNode.get_children():
		if not (String(node.get_path()) in ignoredChilds):
			set_pause_scene(node, pause, ignoredChilds)



