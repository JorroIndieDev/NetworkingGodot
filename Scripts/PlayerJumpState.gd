class_name PlayerJumpState
extends PlayerState

var was_runing: bool = false;

func Enter() -> void:
	if not is_multiplayer_authority(): return
	
	animator.play("PlayerAnimations/JumpStart");
	player.velocity.y = sqrt(player.jump_height * 3 * gravity);
	was_runing = true if parent_node.current_state.name == "PlayerSprintState" else false;

func Exit() -> void:
	pass

func Update(_delta: float) -> void:
	pass
 
func Physics_update(_delta: float) -> void:
	Moving_Player(was_runing);
	
	if player.is_on_floor():
		transitioned.emit("PlayerLandingState");
	
	elif !player.is_on_floor() and player.velocity.y < 1:
		transitioned.emit("PlayerFallingState");
	
