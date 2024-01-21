extends Node

var player_entered: bool = false
var player_in_area
@onready var tp_position: Node3D = $TopOfCylinder/TpPosition

@export var PlayerScene = preload("res://GameScenes/player.tscn")

@export var PORT: int = 9999;
@export var IP_ADRESS: StringName;
@export var MAX_CLIENTS:int;

@onready var main_menu: CanvasLayer = $CanvasLayer
@onready var address_entry: LineEdit = $CanvasLayer/IP
@onready var player_name: LineEdit = $CanvasLayer/Name
@onready var player_ui: CanvasLayer = $PlayerUI
@onready var network: Label = $CanvasLayer2/Network


var enet_peer = ENetMultiplayerPeer.new()
var local_player_character
var connected_peer_ids = []

func _ready() -> void:
	multiplayer.peer_connected.connect(_on_peer_connected);
	multiplayer.peer_disconnected.connect(_on_peer_disconnected);
	multiplayer.connected_to_server.connect(_on_connected_ok);
	multiplayer.connection_failed.connect(_on_connected_fail);
	multiplayer.server_disconnected.connect(_on_server_disconnected);

func _on_host_pressed() -> void:
	network.text = "Host"
	main_menu.hide()
	
	enet_peer.create_server(PORT)
	multiplayer.multiplayer_peer = enet_peer
	multiplayer.peer_disconnected.connect(remove_player)
	enet_peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	add_player_character(1)
	SendPlayerInformation(player_name.text,multiplayer.get_unique_id())
	enet_peer.peer_connected.connect(
		func(new_peer_id):
			await get_tree().create_timer(1).timeout
			rpc("add_newly_connected_player_character", new_peer_id)
			rpc_id(new_peer_id, "add_previously_connected_player_characters", connected_peer_ids)
			add_player_character(new_peer_id)
			SendPlayerInformation(player_name.text,multiplayer.get_unique_id())
	)
	

func _on_join_pressed() -> void:
	network.text = "Client"
	main_menu.hide()
	if address_entry.text == null: address_entry.text = "localhost"
	enet_peer.create_client(address_entry.text, PORT)
	enet_peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	multiplayer.multiplayer_peer = enet_peer

func remove_player(peer_id):
	var player = get_node_or_null(str(peer_id))
	if player:
		player.queue_free()

func _on_start_pressed() -> void:
	pass

#func add_player(peer_id):
	#var player = PlayerScene.instantiate()
	#player.name = str(peer_id)
	#player.Name = player_name.text
	#player.set_multiplayer_authority(peer_id)
	#add_child(player)
	#if peer_id == multiplayer.get_unique_id():
		#local_player_character = player
func add_player_character(peer_id):
	connected_peer_ids.append(peer_id)
	var player_character = PlayerScene.instantiate()
	player_character.set_multiplayer_authority(peer_id)
	add_child(player_character)
	if peer_id == multiplayer.get_unique_id():
		local_player_character = player_character

## called on the server and clients
func _on_peer_connected(id):
	print("player connected " +str(id));

## called on the server and clients
func _on_peer_disconnected(id):
	print("player disconnected " + str(id));

## called only from clients
func _on_connected_ok():
	print("Conneced to server");
	SendPlayerInformation.rpc_id(1, player_name.text, multiplayer.get_unique_id())

## called only from clients
func _on_connected_fail():
	print("Connection Failed");

## called only from clients
func _on_server_disconnected():
	print("Server Down");


'''
	Code above is for networking 
	Code bellow manages the world
	And @rpc calls
'''
func _unhandled_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		player_ui.visible = !player_ui.visible

func _physics_process(_delta: float) -> void:
	if player_entered and Input.is_action_just_pressed("Interact"):
		player_in_area.global_position = tp_position.global_position

func _on_area_3d_body_entered(body) -> void: # needed to implement for two players or more
	if body is Player:
		print("Player Entered")
		player_entered = true
		player_in_area = body

func _on_area_3d_body_exited(body) -> void: # same
	if body is Player:
		player_entered = false
		

func _on_color_picker_color_changed(color: Color) -> void:
	local_player_character.rpc("set_color",color)
	for connected_peer in connected_peer_ids:
		if connected_peer != local_player_character.multiplayer.get_unique_id():
			var otherPeer = get_node_or_null(str(connected_peer))
			otherPeer.body_mesh_material.albedo_color = color
			print("OtherPeersConnected ", otherPeer)
			UpdatePlayerInformation.rpc(connected_peer,color)
	local_player_character.body_mesh_material.albedo_color = color

@rpc("any_peer")
func SendPlayerInformation(Name,id,color: Color = Color(1,1,1,1)):
	if !GameManager.Players.has(id):
		GameManager.Players[id]={
			"Pname" : Name,
			"id" : id,
			"color" : color
		}
	
	if multiplayer.is_server():
		for i in GameManager.Players:
			SendPlayerInformation.rpc(GameManager.Players[i].Pname,i)

@rpc("any_peer")
func UpdatePlayerInformation(id,color: Color = Color(1,1,1,1)):
	if GameManager.Players.has(id):
		GameManager.Players[id].color = color
		if multiplayer.is_server():
			for i in GameManager.Players:
				UpdatePlayerInformation.rpc(GameManager.Players[i].id, GameManager.Players[i].color)
		get_node_or_null(str(id)).applyData(id, color)

@rpc
func add_newly_connected_player_character(new_peer_id):
	add_player_character(new_peer_id)
	
@rpc
func add_previously_connected_player_characters(peer_ids):
	for peer_id in peer_ids:
		add_player_character(peer_id)
