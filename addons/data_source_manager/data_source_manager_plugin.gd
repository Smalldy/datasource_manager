@tool
extends EditorPlugin


func _enter_tree() -> void:
	# Initialization of the plugin goes here.
	add_autoload_singleton("DataSourceManager", "res://addons/data_source_manager/data_source_manager.gd")
	pass


func _exit_tree() -> void:
	remove_autoload_singleton("DataSourceManager")
	# Clean-up of the plugin goes here.
	pass
