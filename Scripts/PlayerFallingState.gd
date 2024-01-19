class_name PlayerFallingState
extends PlayerState

var was_runing: bool = false;
var falling_hard: bool = false;

func Enter() -> void:
	if not is_multiplayer_authority(): return
	animator.play("PlayerAnimations/JumpIdle");
	was_runing = true if parent_node.current_state.name == "PlayerSprintState" else false;

func Exit() -> void:
	falling_hard = false
	
func Update(_delta: float) -> void:
	pass
 
func Physics_update(_delta: float) -> void:
	if not is_multiplayer_authority(): return
	Moving_Player(was_runing);
	
	if player.velocity.y < -20:
		animator.play("PlayerAnimations/FallingHard");
		falling_hard = true
		
	if player.is_on_floor() and !falling_hard:
		transitioned.emit("PlayerLandingState");
		
	elif player.is_on_floor() and falling_hard:
		transitioned.emit("PlayerLandHardState");
		
