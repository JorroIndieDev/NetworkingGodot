class_name Player
extends CharacterBody3D

@onready var camera_mount: Node3D = $CameraMount;
@onready var model: Node3D = $Model;
@onready var state_machine: StateMachine = $StateMachine
#@onready var multiplayer_synchronizer: MultiplayerSynchronizer = $MultiplayerSynchronizer

@export var animationPlayer: AnimationPlayer;
@export var Name: String

@export var max_speed: float = 5.0;
@export var acceleration: float = 50.0;
@export var jump_height: float = 2.0;

## Horizontal mouse sensativity
@export var mouse_sense_horizontal: float = 0.2;
## Vertical mouse sensativity
@export var mouse_sense_vertical: float = 0.2;

# Get the gravity from the project settings to be synced with RigidBody nodes.
@export var gravity_multiplier: float = 1.5;
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity") * gravity_multiplier;

@export var input_dir: Vector2
@export var direction: Vector3
func _enter_tree() -> void:
	set_multiplayer_authority(str(name).to_int())

func _ready() -> void:
	if not is_multiplayer_authority(): return
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED;
	$CameraMount/Camera3D.current = true

func _input(event) -> void:
	if not is_multiplayer_authority(): return
	
	if (event is InputEventMouseMotion) and (Input.mouse_mode == Input.MOUSE_MODE_CAPTURED):
		
		rotate_y(
			deg_to_rad(-event.relative.x * mouse_sense_horizontal)
			);
		
		model.rotate_y( #note to take a look at tweens because this is not working correctly
			deg_to_rad(event.relative.x * mouse_sense_horizontal)
			);
		
		camera_mount.rotate_x(
			deg_to_rad(-event.relative.y * mouse_sense_vertical)
			);
		camera_mount.rotation.x = clamp(
			camera_mount.rotation.x, deg_to_rad(-90), deg_to_rad(45));


func _physics_process(delta) -> void:
	if not is_multiplayer_authority(): return
	
	input_dir = Input.get_vector("Left", "Right", "Forward", "Backwards");
	direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized();
	
	if !is_on_floor() and velocity.y < 1:
		state_machine.on_child_transitioned("PlayerFallingState");
	
	if not is_on_floor():
		velocity.y -= gravity * delta;
	move_and_slide();
