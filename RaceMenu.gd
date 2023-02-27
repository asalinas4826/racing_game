extends Node2D



func _on_TrackOneButton_pressed():
	get_tree().change_scene("res://RaceOne.tscn")


func _on_TrackTwoButton_pressed():
	print("To Track Two!")
	
	
func _on_BackButton_pressed():
	get_tree().change_scene("res://MainMenu.tscn")
