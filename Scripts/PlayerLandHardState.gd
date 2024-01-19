class_name PlayerLandHardState
extends PlayerState


func Enter() -> void:
	if not is_multiplayer_authority(): return
	
	animator.play("PlayerAnimations/FallingFlat");
	
	player.velocity.x = move_toward(
		player.velocity.x, 0, player.max_speed
		);
	player.velocity.z = move_toward(
		player.velocity.z, 0, player.max_speed
		);
	
func Exit() -> void:
	pass
	
func Update(_delta: float) -> void:
	pass
 
func Physics_update(_delta: float) -> void:
	transitioned.emit("PlayerRecoverFallState");


