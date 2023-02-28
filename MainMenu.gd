extends Node2D

func _ready():
	if not MenuMusic.playing:
		MenuMusic.play()


func _on_PlayButton_pressed():
	get_tree().change_scene("res://RaceMenu.tscn")


func _on_QuitButton_pressed():
	get_tree().quit()
