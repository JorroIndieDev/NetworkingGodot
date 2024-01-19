class_name StateMachine
extends Node
 
@export var current_state: State;
var states: Dictionary = {};
 
func _ready():
	if not is_multiplayer_authority(): return
	for child in get_children():
		if child is State:
			states[child.name] = child;
			child.transitioned.connect(on_child_transitioned);
		else:
			push_warning("State machine contains child which is not 'State'");
			
	current_state.Enter();
	print(states);

func _process(delta):
	if current_state:
		current_state.Update(delta);

func _physics_process(delta):
	if current_state:
		current_state.Physics_update(delta);

func on_child_transitioned(new_state_name: StringName) -> void:
	var new_state = states.get(new_state_name);
	if new_state != null:
		if new_state != current_state:
			current_state.Exit();
			new_state.Enter();
			
			#print("\nCurrent state: " + str(current_state));
			#print("New state: " + str(new_state));
			
			current_state = new_state;
			
			
	else:
		push_warning(str(current_state)+" Called transition on a state that does not exist " + str(new_state_name));
