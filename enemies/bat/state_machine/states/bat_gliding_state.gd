class_name BatGlidingState;
extends AbstractBatState;

@export var move_speed: float = 75;
var gravity_factor = 1.4;
@export var flap_after_x_seconds_timer: float = 1;
@export var pathfind_min_distance: float = 2;


func enter(_from: AbstractState) -> void:
	_transition_to_flap_state_after_timeout();
	pass;

func exit(_to: AbstractState) -> void:
	pass;

func process(_delta: float) -> void:
	body.process_attack();

func physics_process(delta: float) -> void:
	body.velocity = (
		body._astar_get_next_step_to_target(
			Main.instance.player.global_position,
			Main.STANDARD_UNIT * 1
		)
	).normalized() * move_speed + body.get_gravity() * delta * gravity_factor;
	
func _transition_to_flap_state_after_timeout()->void:
	await get_tree().create_timer(flap_after_x_seconds_timer).timeout;
	transition.emit("Flap");
