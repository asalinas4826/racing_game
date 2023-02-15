extends Node2D

func _ready():
	var player2Texture = preload("res://assets/blue_car.png")
	get_node("TrackOne/Player/Car2/Sprite").set_texture(player2Texture)

	set_pause_scene(get_node("TrackOne"), 1)
	set_process(false)
	
func _process(_delta):
	fade_button_and_title()
	
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
	set_process(true)



func start_race():
	set_pause_scene(get_node("TrackOne"), 0)
	
	
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
