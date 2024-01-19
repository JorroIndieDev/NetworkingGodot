extends Node

func _input(_event: InputEvent) -> void:
	
	if Input.is_action_just_pressed("ui_accept"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED;
		
	if Input.is_action_just_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE;
