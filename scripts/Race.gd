extends Node2D

var raceLength = 18 # how many laps for a race

func _ready():
	var player2Texture = preload("res://assets/blue_car.png")
	get_node("TrackOne/Player/Car2/Sprite").set_texture(player2Texture)

	set_pause_scene(get_node("TrackOne"), 1)
	set_process(false)
	
	get_node("HUD/EndButton").hide()
	
	get_node("HUD/P1Laps").hide()
	get_node("HUD/P2Laps").hide()


func _process(_delta):
	fade_button_and_title()


func fade_button_and_title() -> void:
	var button = get_node("HUD/StartButton")
	if button.modulate.a8 > 0:
		button.modulate.a8 -= 16
	
	var title = get_node("HUD/TrackTitle")
	if title.modulate.a8 > 0:	
		title.modulate.a8 -= 16


func prepare_race():
	get_node("RaceMusic").play()
	get_node("StartTimer").start()
	get_node("HUD/StartButton").disabled = true
	set_process(true)


func start_race():
	set_pause_scene(get_node("TrackOne"), 0)
	
	var textLabelOne = get_node("HUD/P1Laps")
	var textLabelTwo = get_node("HUD/P2Laps")
	textLabelOne.text = "P1: 1/" + str(raceLength)
	textLabelTwo.text = "P2: 1/" + str(raceLength)
	textLabelOne.show()
	textLabelTwo.show()


func _on_enter_finish(body : KinematicBody2D) -> void:
	if not body.backwardsLap and body.position.x < get_node("FinishLine").position.x:
		body.lapCount += 1
		update_lap_text(body)
		
		comeback()
		
		if body.lapCount > raceLength: # 18 allows music to play through at least once, use 2 or 3 for testing
			end_race(body)

#	print(body.lapCount)
#	print(body.position.x)
#	print(body.backwardsLap)


func update_lap_text(body : KinematicBody2D) -> void:
	var textLabel
	if not body.playerTwo:
		textLabel = get_node("HUD/P1Laps")
		textLabel.text = "P1: "
	else:
		textLabel = get_node("HUD/P2Laps")
		textLabel.text = "P2: "
	textLabel.text += str(body.lapCount) + "/" + str(raceLength)


func _on_exit_finish(body):
	if body.position.x < get_node("FinishLine").position.x:
		body.backwardsLap = true
	else:
		body.backwardsLap = false


func end_race(winner : KinematicBody2D):
	get_node("FinishLine").set_deferred("monitoring", false)
	var winTexture
	if not winner.playerTwo:
		winTexture = load("res://assets/Player 1 Wins.png")
	else:
		winTexture = load("res://assets/Player 2 Wins.png")
	get_node("HUD/WinMessage").set_texture(winTexture )
	get_node("HUD/EndButton").show()
	get_node("HUD/EndButton").disabled = false
	get_node("RaceMusic").stop()
	get_node("WinMusic").play()
	
func _on_EndButton_pressed():
	get_node("WinMusic").stop()
	get_tree().change_scene("res://RaceMenu.tscn")


func comeback() -> void:
	var car1 = get_node("TrackOne/Player/Car")
	var car2 = get_node("TrackOne/Player/Car2")
#	print("\nPlayer 1: " + str(car1.lapCount))
#	print("Player 2: " + str(car2.lapCount))
	
	if car1.lapCount > car2.lapCount and car2.speed < 600:
		car2.speed *= 1.5
#		print("p1's speed is " + str(car1.speed))
#		print("increased p2's speed to " + str(car2.speed))
	elif car2.lapCount > car1.lapCount and car1.speed < 600:
		car1.speed *= 1.5
#		print("increased p1's speed to " + str(car1.speed))
#		print("p2's speed is " + str(car1.speed))
	elif car1.lapCount == car2.lapCount:
		car1.speed = 400
		car2.speed = 400
#		print("reset speed")
#		print("p1's speed is " + str(car1.speed))
#		print("p2's speed is " + str(car2.speed))


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

