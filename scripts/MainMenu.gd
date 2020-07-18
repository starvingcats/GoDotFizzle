extends Node2D

export (String, FILE, "*.tscn") var First_Level: String

func _ready():
	MenuEvent.MainMenu = true
	Hud.visible = false
	GuiBrain.gui_collect_focusgroup()
	Settings.get_controls()

func _on_Button_pressed():
	print(First_Level)
	Event.emit_signal("ChangeScene", First_Level)

func _exit_tree()->void:
	MenuEvent.MainMenu = false				#switch bool for easier pause menu detection and more
	GuiBrain.gui_collect_focusgroup()	#Force re-collect buttons because main meno wont be there

func _on_Add_Controller_pressed():
	if not "p2_" in Game.registered_player_prefixes:
		Game.registered_player_prefixes.append("p2_")

func _on_Quit_pressed():
	Event.emit_signal("Exit")

func _on_Options_pressed():
	MenuEvent.Options = true
