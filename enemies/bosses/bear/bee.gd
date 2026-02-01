class_name Bee;
extends AbstractEnemy;

@export var change_direction_time: float = 2.0;
@export var travel_speed: float = 100;
@export var wait_every: float = 2.5;
@export var wait_duration: float = 1.5;
var _travel_direction: Vector2;
var _brownian_variance: Vector2 = Vector2(0.01, 0.01);
var _is_dying = false;
var _c_wait_every_timer := 0.0;
var _c_wait_duration_timer := 0.0;

func _ready() -> void:
	_travel_direction = (
		Main.instance.player.global_position - global_position
	).normalized();

func _process(delta: float) -> void:
	if _c_wait_every_timer < wait_every:
		_c_wait_every_timer += delta;
		var bee_to_player_vector = (
			Main.instance.player.global_position - global_position
		);
		_travel_direction = lerp(
			_travel_direction,
			bee_to_player_vector.normalized(),
			delta / change_direction_time,
		) + _get_brownian_motion_vector2();
	else:
		if _c_wait_duration_timer < wait_duration:
			_c_wait_duration_timer += delta;
			var bm = _get_brownian_motion_vector2();
			_travel_direction = lerp(_travel_direction, bm, delta * 10 / change_direction_time);
		else:
			_c_wait_duration_timer = 0;
			_c_wait_every_timer = 0;

func _physics_process(delta: float) -> void:
	if _is_dying:
		rotation_degrees += 90 * delta;
		velocity += get_gravity() * delta;
	else:
		velocity = _travel_direction * travel_speed;
	move_and_slide();

func _free_after_x_seconds(x: float)->void:
	await get_tree().create_timer(x).timeout;
	queue_free();

func _on_player_enter_bee_attack_area(body: Node2D)->void:
	if body is Player and !_is_dying:
		body.damage(1, Vector2.ZERO, Vector2.ZERO, 0);
		gib_and_kill();

func _get_brownian_motion_vector2()->Vector2:
	return Vector2(randf_range(
		-_brownian_variance.x, _brownian_variance.x
	), randf_range(
		-_brownian_variance.y, _brownian_variance.y
	));

func gib_and_kill()->void:
	_is_dying = true;
	on_death.emit();
	await get_tree().create_timer(5).timeout;
	queue_free();
