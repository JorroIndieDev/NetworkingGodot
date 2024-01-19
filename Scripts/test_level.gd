extends Node

var player_entered: bool = false
var player_in_area
@onready var tp_position: Node3D = $TopOfCylinder/TpPosition

@export var PlayerScene = preload("res://GameScenes/player.tscn")

@export var PORT: int = 9999;
@export var IP_ADRESS: StringName;
@export var MAX_CLIENTS:int;

@onready var main_menu: CanvasLayer = $CanvasLayer
@onready var address_entry: LineEdit = $CanvasLayer/LineEdit

var enet_peer = ENetMultiplayerPeer.new()


func _ready() -> void:
	pass

func _on_host_pressed() -> void:
	main_menu.hide()
#	hud.show()
	
	enet_peer.create_server(PORT)
	multiplayer.multiplayer_peer = enet_peer
	multiplayer.peer_connected.connect(add_player)
	multiplayer.peer_disconnected.connect(remove_player)
	
	add_player(multiplayer.get_unique_id())


func _on_join_pressed() -> void:
	main_menu.hide()
#	hud.show()
	
	enet_peer.create_client(address_entry.text, PORT)
	multiplayer.multiplayer_peer = enet_peer

func remove_player(peer_id):
	var player = get_node_or_null(str(peer_id))
	if player:
		player.queue_free()


func _on_start_pressed() -> void:
	pass

func add_player(peer_id):
	var player = PlayerScene.instantiate()
	player.name = str(peer_id)
	add_child(player)






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
		
