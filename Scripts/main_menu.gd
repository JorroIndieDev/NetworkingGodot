extends Control

@export var scene: PackedScene;
@export var PlayerScene : PackedScene

@export var PORT: int;
@export var IP_ADRESS: StringName;
@export var MAX_CLIENTS:int;

@onready var canvas_layer: CanvasLayer = $".."

var peer = ENetMultiplayerPeer.new()

#@onready var PlayerList = {}
#@onready var v_box_container_2: VBoxContainer = $VBoxContainer2
#
#func _ready() -> void:
	#multiplayer.peer_connected.connect(_on_peer_connected);
	#multiplayer.peer_disconnected.connect(_on_peer_disconnected);
	#multiplayer.connected_to_server.connect(_on_connected_ok);
	#multiplayer.connection_failed.connect(_on_connected_fail);
	#multiplayer.server_disconnected.connect(_on_server_disconnected);
#
## called on the server and clients
#func _on_peer_connected(id):
	#print("player connected " +str(id));
#
## called on the server and clients
#func _on_peer_disconnected(id):
	#print("player disconnected " + str(id));
#
## called only from clients
#func _on_connected_ok():
	#print("Conneced to server");
	#SendPlayerInformation.rpc_id(1, $LineEdit.text, multiplayer.get_unique_id())
#
## called only from clients
#func _on_connected_fail():
	#print("Connection Failed");
#
## called only from clients
#func _on_server_disconnected():
	#print("Server Down");
#
#@rpc("any_peer")
#func SendPlayerInformation(Name,id):
	#if !GameManager.Players.has(id):
		#GameManager.Players[id]={
			#"name" : Name,
			#"id" : id
		#}
	#
	#if multiplayer.is_server():
		#for i in GameManager.Players:
			#SendPlayerInformation.rpc(GameManager.Players[i].name,i)
#
#
#@rpc("any_peer","call_local")
#func StartGame():
	#var inst_scene = scene.instantiate()
	#get_tree().root.add_child(inst_scene)
	#self.hide()
#
#func _on_host_pressed() -> void:
	#canvas_layer.hide()
	#
	#peer.create_server(PORT)
	#multiplayer.multiplayer_peer = peer
	#multiplayer.peer_connected.connect(add_player)
	#
	#add_player(multiplayer.get_unique_id())
#
#
#func _on_join_pressed() -> void:
	#canvas_layer.hide()
	#
	#peer.create_client(IP_ADRESS,PORT)
	#multiplayer.multiplayer_peer = peer
#
#
#func _on_start_pressed() -> void:
	#pass
#
#
#func add_player(peer_id):
	#var player = PlayerScene.instantiate()
	#player.name = str(peer_id)
	#add_child(player)
