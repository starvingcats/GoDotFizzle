extends Node2D

export (String, FILE, "*.tscn") var First_Level: String

func _ready():
	MenuEvent.MainMenu = true
	GuiBrain.gui_collect_focusgroup()

func _on_Button_pressed():
	print(First_Level)
	Event.emit_signal("ChangeScene", First_Level)

func _exit_tree()->void:
	MenuEvent.MainMenu = false				#switch bool for easier pause menu detection and more
	GuiBrain.gui_collect_focusgroup()	#Force re-collect buttons because main meno wont be there

func _on_Add_Controller_pressed():
	if not "p2_" in Game.registered_player_prefixes:
		Game.registered_player_prefixes.append("p2_")
