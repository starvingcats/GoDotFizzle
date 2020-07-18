extends Node

onready var hp: = $CanvasLayer/Control/MarginContainer/VBoxContainer/Top/HP
onready var score: = $CanvasLayer/Control/MarginContainer/VBoxContainer/Top/Score
onready var gui: = $CanvasLayer/GUI

var visible: = false setget set_visible

func _ready()->void:
	# gui.visible = visible
	pass

func set_visible(value: bool)->void:
	visible = value
	gui.visible = value
