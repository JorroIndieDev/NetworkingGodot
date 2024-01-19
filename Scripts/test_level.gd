extends Node

var player_entered: bool = false
var player_in_area
@onready var tp_position: Node3D = $TopOfCylinder/TpPosition

@export var PlayerScene : PackedScene

@export var PORT: int;
@export var IP_ADRESS: StringName;
@export var MAX_CLIENTS:int;

@onready var canvas_layer: CanvasLayer = $CanvasLayer

var peer = ENetMultiplayerPeer.new()


func _ready() -> void:
	pass

func _on_host_pressed() -> void:
	canvas_layer.hide()
	
	peer.create_server(PORT)
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(add_player)
	print(multiplayer.get_unique_id()) #########################
	add_player(multiplayer.get_unique_id())


func _on_join_pressed() -> void:
	canvas_layer.hide()
	
	peer.create_client("localhost", PORT)
	multiplayer.multiplayer_peer = peer


func _on_start_pressed() -> void:
	pass


func add_player(peer_id):
	var player = PlayerScene.instantiate()
	player.name = str(peer_id)
	call_deferred("add_child",player,true)
	
func _physics_process(_delta: float) -> void:
	if player_entered and Input.is_action_just_pressed("Interact"):
		player_in_area.global_position = tp_position.global_position

func _on_area_3d_body_entered(body: Node3D) -> void: # needed to implement for two players or more
	if body is Player:
		print("Player Entered")
		player_entered = true
		player_in_area = body


func _on_area_3d_body_exited(body: Node3D) -> void: # same
	if body is Player:
		player_entered = false
		
