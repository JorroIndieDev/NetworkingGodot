class_name PlayerSprintState
extends PlayerState

func Enter() -> void:
	if not is_multiplayer_authority(): return
	
	animator.play("PlayerAnimations/running");



func Exit() -> void:
	player.velocity.x = move_toward(
		player.velocity.x, 0, player.max_speed
		);
	player.velocity.z = move_toward(
		player.velocity.z, 0, player.max_speed
		);
	
func Update(_delta: float) -> void:
	pass
 
func Physics_update(_delta: float) -> void:
	Moving_Player(true);
	
	if !player.direction:
		transitioned.emit("PlayerIdleState");
		
	elif !Input.is_action_pressed("Sprint") and player.direction:
		transitioned.emit("PlayerWalkState");
		
	elif Input.is_action_just_pressed("Jump"):
		transitioned.emit("PlayerJumpState");
	
