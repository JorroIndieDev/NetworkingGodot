'''

Note to try and remove the synchronizers and add everything by rpc

'''
class_name Player
extends CharacterBody3D

@onready var camera_mount: Node3D = $CameraMount;
@onready var model: Node3D = $Model;
@onready var state_machine: StateMachine = $StateMachine

@onready var body_mesh: MeshInstance3D = $"Model/Root Scene/RootNode/Skeleton3D/Alpha_Surface"
@onready var body_mesh_material: StandardMaterial3D = StandardMaterial3D.new()
#@onready var name_tag: Label3D = $NameTag.text
#@onready var id_tag: Label3D = $IDTag.text

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
@onready var multiplayerID

func _enter_tree():
	name = str(get_multiplayer_authority())
	multiplayerID = str(name).to_int()
	print("multiplayerID ",multiplayerID) # player.gd
	$IDTag.text = str(name)
	$NameTag.text = GameManager.Players[multiplayerID].Pname

func _ready():
	if not is_multiplayer_authority(): return
	body_mesh.set_surface_override_material(0,StandardMaterial3D.new())
	body_mesh_material = body_mesh.get_active_material(0)
	body_mesh_material.albedo_color = Color(1,1,1,1)
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED;
	$CameraMount/Camera3D.current = true
	print("GameManager.Players ",GameManager.Players)
	await get_tree().create_timer(1).timeout


func _unhandled_input(event: InputEvent) -> void:
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

func _process(_delta: float) -> void:
	pass

func _physics_process(delta) -> void:
	if not is_multiplayer_authority(): return
	
	input_dir = Input.get_vector("Left", "Right", "Forward", "Backwards");
	direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized();
	
	if !is_on_floor() and velocity.y < 1:
		state_machine.on_child_transitioned("PlayerFallingState");
	
	if not is_on_floor():
		velocity.y -= gravity * delta;
	move_and_slide();


func applyData(id,color): # player.gd
	#if id != multiplayer.get_unique_id(): return
	#body_mesh_material.albedo_color = color
	rpc("color_rpc_",color)
	print("applyData: ID: ",id," Color: ",color)
	

@rpc("any_peer", "call_local", "reliable",0)
func color_rpc_(color):
	body_mesh_material.albedo_color = color
	print( "color_rpc_ sent from " + str( 
		multiplayer.get_remote_sender_id() ) + " to " + str( multiplayer.get_unique_id() ) 
		)

@rpc("unreliable")
func remote_set_position(authority_position):
	global_position = authority_position
	
@rpc("authority","call_local","unreliable",1)
func set_color(color):
	print( "Colour change from " + str( multiplayer.get_remote_sender_id() ) + " to " + str( multiplayer.get_unique_id() ) )
