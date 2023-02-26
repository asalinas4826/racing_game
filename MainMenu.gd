extends Node2D

func _ready():
	MenuMusic.play()
	pass


func _on_PlayButton_pressed():
	get_tree().change_scene("res://RaceMenu.tscn")
	
	# enable race buttons and render race menu sprite
	
func _on_QuitButton_pressed():
	get_tree().quit()
