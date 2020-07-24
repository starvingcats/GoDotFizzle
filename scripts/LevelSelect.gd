extends PopupPanel

export (String, FILE, "*.tscn") var First_Level: String
export (String, FILE, "*.tscn") var Second_Level: String

func _ready():
	pass # Replace with function body.

func _on_Level_1_pressed():
	Event.emit_signal("ChangeScene", First_Level)
	hide()

func _on_Level_2_pressed():
	Event.emit_signal("ChangeScene", Second_Level)
	hide()
