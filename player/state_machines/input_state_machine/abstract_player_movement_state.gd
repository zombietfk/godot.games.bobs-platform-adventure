@abstract
class_name AbstractPlayerMovementState;
extends AbstractState;

@export var body: Player;

func _clamp_horizontal_movement(max_movement_speed: float):
	body.velocity.x = clamp(
		body.velocity.x,
		-max_movement_speed,
		max_movement_speed
	);

func _clamp_vertical_movement(max_movement_speed: float):
	body.velocity.y = clamp(
		body.velocity.y,
		-max_movement_speed,
		max_movement_speed
	);

func _process_horizontal_input(movement_context: PlayerMovementContext):
	movement_context.movement_impetus = Vector2.ZERO;
	if Input.is_action_pressed("move_right"):
		movement_context.movement_impetus += (
			Vector2.RIGHT * movement_context.movement_speed
		);
	if Input.is_action_pressed("move_left"):
		movement_context.movement_impetus += (
			Vector2.LEFT * movement_context.movement_speed
		);

func _kill_player()->void:
	transition.emit("Dead");
	
func _add_slowing_web(by: Web):
	var webs = state_machine.get_context("MovementContext").slowed_by_webs as Array[Web];
	webs.push_back(by);
	pass;
	
func _remove_slowing_web(by: Web):
	var webs = state_machine.get_context("MovementContext").slowed_by_webs as Array[Web];
	var web_index = webs.find(by);
	if web_index != -1:
		webs.remove_at(web_index);
	pass;
