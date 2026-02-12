@tool
extends EditorPlugin

var dock : EditorDock

func _enable_plugin() -> void:
	# Add autoloads here.
	pass

func _disable_plugin() -> void:
	# Remove autoloads here.
	pass

func _enter_tree() -> void:
	EditorInterface.get_base_control().add_child(preload("res://addons/jumpscare/jumpscare_scene.tscn").instantiate())

func _exit_tree() -> void:
	remove_dock(dock)
	dock.queue_free()
