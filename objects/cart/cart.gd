class_name Cart;
extends CharacterBody2D;

var is_in_motion := false;
var movement_speed_acceleration := 312.0;
var movement_speed_aggregate := 0.0;
var max_movement_speed := 480.0;
var max_brakeing_speed := 240.0;
var jump_strength := 1000.0;
var last_travel_direction := Vector2.ZERO;
var _c_change_rotation_timer := 0.0;
var change_rotation_timer := 0.2;
var target_rotation := 0.0;
var disembarked := false;
var _travel_time := 0.0;
@onready var cart_sound : AudioStreamPlayer = $AudioStreamPlayer;

func _process(_delta: float) -> void:
	if _is_player_in_cart():
		if is_in_motion == false:
			cart_sound.play();
		is_in_motion = true;
		Main.instance.player.velocity = Vector2.ZERO;

func _physics_process(delta: float) -> void:
	$RayCast2D.global_rotation = 0;
	if _c_change_rotation_timer >= 0:
		_c_change_rotation_timer -= delta;
		rotation = lerp(
			rotation,
			target_rotation,
			(change_rotation_timer - _c_change_rotation_timer) / change_rotation_timer
		);
	else:
		if !is_on_floor() and velocity.y < 0:
			rotation_degrees -= 25 * delta;
	if is_in_motion:
		for n in $ShapeCast2D.get_collision_count():
			var body = $ShapeCast2D.get_collider(n);
			if body is AbstractEnemy:
				body.gib_and_kill();
		if Main.instance.player.get_parent() != self:
			Main.instance.player.reparent(self);
		Main.instance.player.global_position = $CharacterLockArea.global_position;
		if $RayCast2D.is_colliding():
			var floor_normal = $RayCast2D.get_collision_normal();
			if _c_change_rotation_timer <= 0:
				last_travel_direction = Vector2(-floor_normal.y, floor_normal.x);
				target_rotation = floor_normal.angle() + PI / 2
				_c_change_rotation_timer = change_rotation_timer;
		_travel_time = delta;
		velocity += last_travel_direction * movement_speed_acceleration * _travel_time;
		if Input.is_action_just_pressed("jump"):
			_jump_in_cart();
		velocity += get_gravity() * delta;
	else:
		velocity = get_gravity();
	move_and_slide();
	if velocity.y >= 0:
		apply_floor_snap();
	if Input.is_action_pressed("move_left") and is_on_floor() and is_in_motion:
		velocity.x = clamp(velocity.x, -max_brakeing_speed, max_brakeing_speed);
		$BrakeParticles2D.emitting = true;
	else:
		velocity.x = clamp(velocity.x, -max_movement_speed, max_movement_speed);
		$BrakeParticles2D.emitting = false;

func _jump_in_cart() -> void:
	if is_on_floor():
		velocity.x *= 1.5;
		velocity.y -= jump_strength * (clamp(velocity.x, -max_movement_speed, max_movement_speed) / max_movement_speed);

func _is_player_in_cart() -> bool:
	if disembarked:
		return false;
	return $InCartArea.overlaps_body(Main.instance.player);

func _disembark_player()->void:
	Main.instance.player.reparent(Main.instance);
	cart_sound.stop();
	Main.instance.player.velocity.y -= 600;
	velocity.x = 0;
	disembarked = true;
	is_in_motion = false;
	
