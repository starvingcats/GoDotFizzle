extends CanvasLayer

export (String, FILE, "*.tscn") var First_Level: String

onready var LevelSelect = Game.get_node("PopUpLayer/LevelSelect")

func _ready():
	MenuEvent.MainMenu = true
	Hud.visible = false
	GuiBrain.gui_collect_focusgroup()

func _on_Button_pressed():
	LevelSelect.popup_centered()
	# Event.emit_signal("ChangeScene", First_Level)

func _exit_tree()->void:
	MenuEvent.MainMenu = false				#switch bool for easier pause menu detection and more
	GuiBrain.gui_collect_focusgroup()	#Force re-collect buttons because main meno wont be there

func _on_Quit_pressed():
	Event.emit_signal("Exit")

func _on_Options_pressed():
	MenuEvent.Options = true
