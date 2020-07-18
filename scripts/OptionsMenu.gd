extends CanvasLayer

func _ready()->void:
	#show main section and hide controls
	MenuEvent.connect("Options", self, "on_show_options")
	MenuEvent.Controls = false
	set_resolution()

func on_show_options(value:bool)->void:
	$Control.visible = value
	MenuEvent.Controls = false

func _on_Back_pressed()->void:
	print(Settings.Fullscreen)
	Settings.save_settings()
	MenuEvent.Options = false

func _on_Fullscreen_pressed():
	Settings.Fullscreen = find_node("Fullscreen").pressed

func _on_Borderless_pressed()->void:
	Settings.Borderless = find_node("Borderless").pressed

func set_resolution()->void:
	find_node("Fullscreen").pressed = Settings.Fullscreen
	find_node("Borderless").pressed = Settings.Borderless
