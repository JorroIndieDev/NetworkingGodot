class_name PlayerState
extends State

@export var player : Player = owner;
@export var animator: AnimationPlayer;

@onready var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity");
@onready var parent_node = get_parent();

var speed_multiplier: float;

func Enter() -> void:
	if not is_multiplayer_authority(): return
	pass
	
func Exit() -> void:
	if not is_multiplayer_authority(): return
	pass
	
func Update(_delta: float) -> void:
	if not is_multiplayer_authority(): return
	pass
	
func Physics_update(_delta: float) -> void:
	if not is_multiplayer_authority(): return
	pass

func Moving_Player(sprint: bool) -> void:
	if not is_multiplayer_authority(): return
	speed_multiplier = 1.5 if sprint else 1.0;
	if player.direction:
		player.velocity.x = player.direction.x * (player.max_speed * speed_multiplier);
		player.velocity.z = player.direction.z * (player.max_speed * speed_multiplier);
		
		player.model.rotation.y = lerp_angle(
			player.model.rotation.y,
			 atan2(-player.input_dir.x, -player.input_dir.y), 0.15
			);
		
	else:
		
		player.velocity.x = move_toward(
			player.velocity.x, 0, player.max_speed
			);
		player.velocity.z = move_toward(
			player.velocity.z, 0, player.max_speed
			);
