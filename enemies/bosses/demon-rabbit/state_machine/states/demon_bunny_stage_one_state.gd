class_name DemonBunnyStageOneState;
extends AbstractDemonBunnyState;

@export var idle_jump_timer := 2.0;
var _c_idle_jump_timer := 0.0;

@export var throw_pitchfork_timer := 5.0;
var _c_throw_pitchfork_timer := 0.0;
var _pitchfork_speed := 1000;
var _pitchfork_throw_duration := 1.5;
var _pitchfork_return_duration := 2;
var _is_holding_pitchfork := true;

@export var jump_strength := 500.0;
@export var state_duration_timer := 0.0;
var _c_state_duration_timer := 0.0;

func enter(_from: AbstractState)->void:
	body.sprite_body.play("default");
	_reset_state_variables();

func exit(_to: AbstractState)->void:
	pass;

func process(delta: float)->void:
	if _c_state_duration_timer >= state_duration_timer:
		if !_is_holding_pitchfork:
			return;
		transition.emit("StageTwo");
	_c_state_duration_timer += delta;

func physics_process(delta: float)->void:
	if body.is_on_floor():
		_c_idle_jump_timer += delta;
	if _c_idle_jump_timer > idle_jump_timer:
		_c_idle_jump_timer = 0;
		body.velocity.y -= jump_strength;
	_c_throw_pitchfork_timer += delta;
	if _c_throw_pitchfork_timer > throw_pitchfork_timer:
		_throw_pitchfork_to_and_return(
			body.pitchfork_origin_marker.global_position,
			InterceptUtil.kinematic_body_intercept_2d(
				body.pitchfork.global_position,
				Main.instance.player,
				_pitchfork_speed,
				delta
			) + Vector2.UP * 48,
			_pitchfork_throw_duration,
			_pitchfork_return_duration
		);
		_c_throw_pitchfork_timer = 0;
	body.velocity += body.get_gravity() * delta;
	body.move_and_slide();

func _throw_pitchfork_to_and_return(
	from: Vector2,
	to: Vector2,
	outbound_duration: float,
	inbound_duration: float,
) -> void:
	_is_holding_pitchfork = false;
	var player = Main.instance.player;
	var c_outbound_duration = 0;
	body.pitchfork.rotation = player.global_position.angle_to_point(
		body.pitchfork.global_position
	);
	while c_outbound_duration < outbound_duration:
		body.pitchfork.global_position += (to - from).normalized() * _pitchfork_speed * get_process_delta_time();
		if body.pitchfork.raycast_2d.get_collider() == player:
			player.damage(1, (from - to).normalized(), Vector2(500,500));
		await get_tree().process_frame;
		c_outbound_duration += get_process_delta_time();
	var c_inbound_duration = 0;
	body.pitchfork.rotation = body.global_position.angle_to_point(
		body.pitchfork.global_position
	);
	var current_pitchfork_position = body.pitchfork.global_position;
	while c_inbound_duration < inbound_duration:
		body.pitchfork.animation_player.play("spin_pitchfork");
		body.pitchfork.global_position = lerp(
			current_pitchfork_position,
			body.pitchfork_origin_marker.global_position,
			c_inbound_duration / inbound_duration
		);
		await get_tree().process_frame;
		c_inbound_duration += get_process_delta_time();
	body.pitchfork.animation_player.stop();
	_is_holding_pitchfork = true;

func _reset_state_variables()->void:
	_c_idle_jump_timer = 0.0;
	_c_throw_pitchfork_timer = 0.0;
	_pitchfork_speed = 1000;
	_pitchfork_throw_duration = 1.5;
	_pitchfork_return_duration = 2;
	_is_holding_pitchfork = true;
	_c_state_duration_timer = 0.0;
