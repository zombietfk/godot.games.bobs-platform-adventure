class_name PlayerAirbornState;
extends AbstractPlayerMovementState;

var _movement_context: PlayerMovementContext;
@export var friction_strength: float = 1.0/4;

func enter(_from: AbstractState)->void:
	_movement_context = state_machine.get_context("MovementContext") as PlayerMovementContext;
	if !body.on_kill.is_connected(_kill_player):
		body.on_kill.connect(_kill_player);

func exit(_to: AbstractState)->void:
	if body.on_kill.is_connected(_kill_player):
		body.on_kill.disconnect(_kill_player);
	
func process(_delta: float)->void:
	if body.is_on_floor():
		transition.emit("Grounded");
	
func physics_process(delta: float)->void:
	_process_horizontal_input(_movement_context);
	_process_cancel_jump_input();
	_apply_horizontal_friction(delta);
	if _movement_context.knockback_impetus != Vector2.ZERO:
		body.velocity = _movement_context.knockback_impetus;
	else:
		body.velocity += (
			body.get_gravity() * delta +
			_movement_context.movement_impetus +
			_movement_context.knockback_impetus
		);
	_clamp_horizontal_movement(_movement_context.max_movement_speed);

func _process_cancel_jump_input()->void:
	if body.velocity.y < 0 and Input.is_action_just_released("jump"):
		body.velocity.y = 0;
		
func _apply_horizontal_friction(delta) -> void:
	var friction_unit = sign(body.velocity.x) * (body.get_gravity().length() * delta);
	body.velocity.x -= friction_unit * friction_strength;
