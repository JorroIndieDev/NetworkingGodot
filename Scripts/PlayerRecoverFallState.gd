class_name PlayerRecoverFallState
extends PlayerState

var standing: bool = false

func Enter() -> void:
	animator.play("PlayerAnimations/StandingUp");
	
func Exit() -> void:
	standing = false
	
func Update(_delta: float) -> void:
	pass
 
func Physics_update(_delta: float) -> void:
	if standing:
		
		if !player.direction:
			transitioned.emit("PlayerIdleState");
		
		elif !Input.is_action_pressed("Sprint") and player.direction:
			transitioned.emit("PlayerWalkState");
		
		elif Input.is_action_just_pressed("Jump"):
			transitioned.emit("PlayerJumpState");

func Stood_up():
	standing = true
