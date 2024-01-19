class_name PlayerIdleState
extends PlayerState

func Enter() -> void:
	animator.play("PlayerAnimations/idle(3)");
	
	player.velocity.x = move_toward(
		player.velocity.x, 0, player.max_speed
		);
	player.velocity.z = move_toward(
		player.velocity.z, 0, player.max_speed
		);

func Physics_update(_delta):
	if player.direction:
		transitioned.emit("PlayerWalkState");
		
	elif Input.is_action_pressed("Sprint") and player.direction:
		transitioned.emit("PlayerSprintState");
		
	elif Input.is_action_just_pressed("Jump"):
		transitioned.emit("PlayerJumpState");
