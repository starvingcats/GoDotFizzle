"""
class GDDBManager
"""

class_name GDDBManager

tool
extends EditorPlugin

var DBInterface = preload("./db_interface.tscn")
var db_interface : Node

func _enter_tree():
	add_autoload_singleton("gddb_constants", "res://addons/godot_db_manager/core/GDDBConstants.gd")
	add_autoload_singleton("gddb_types", "res://addons/godot_db_manager/core/GDDBTypes.gd")
	add_autoload_singleton("gddb_globals", "res://addons/godot_db_manager/core/GDDBGlobals.gd")

	# Initialization of the plugin goes here
	db_interface = DBInterface.instance()

	get_editor_interface().get_base_control().add_child(db_interface)
	add_tool_menu_item("Godot Database Manager", self, "open_config")

func _exit_tree():
	# Clean-up of the plugin goes here
	remove_tool_menu_item("Godot Database Manager")
	if(db_interface):
		db_interface.queue_free()

func open_config(UD):
	var window = db_interface.get_node("dlg") as WindowDialog
	if(window):
		window.popup_centered()
