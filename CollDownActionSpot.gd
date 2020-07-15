class_name CoolDownActionSpot

extends Node

export(NodePath) var timer_path
onready var timer_node = get_node(timer_path)
var cooled_down = true

func _ready():
	timer_node.connect("timeout", self, "_on_timer_node_timeout")

func action(player):
	if !cooled_down:
		return
	cooled_down = false
	timer_node.start()
	var execute_fnc = funcref(self, "execute")
	if execute_fnc:
		execute_fnc.call_func(player)

func _on_timer_node_timeout():
	cooled_down = true
