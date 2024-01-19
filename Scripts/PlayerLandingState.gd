class_name PlayerLandingState
extends PlayerState


func Enter() -> void:
	
	animator.play("PlayerAnimations/JumpFallToLanding");
	
func Exit() -> void:
	pass
	
func Update(_delta: float) -> void:
	pass
 
func Physics_update(_delta: float) -> void:
	if player.direction:
		transitioned.emit("PlayerWalkState");
		
	elif Input.is_action_pressed("Sprint") and player.direction:
		transitioned.emit("PlayerSprintState");
		
	else:
		transitioned.emit("PlayerIdleState");
		

