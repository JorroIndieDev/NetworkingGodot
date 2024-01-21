extends Node

class Action:
	func _get(property: StringName) -> bool:
		return Input.is_action_just_pressed(property)

var action = Action.new()

func _unhandled_input(event: InputEvent) -> void:
	
	if event is InputEventKey:
		match true:
			action.Accept:
				Input.mouse_mode = Input.MOUSE_MODE_CAPTURED;
			action.ui_cancel:
				Input.mouse_mode = Input.MOUSE_MODE_VISIBLE;
			action.Tab:
				print(GameManager.Players)

