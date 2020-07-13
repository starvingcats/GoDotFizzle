extends Button


func _on_Resume_pressed():
	print("Haha lost.")
	get_tree().current_scene.get_node("UI/PausePopup").hide()
	get_tree().paused = false


func _on_Quit_pressed():
	get_tree().quit()
