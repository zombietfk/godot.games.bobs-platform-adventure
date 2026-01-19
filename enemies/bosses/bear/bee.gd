class_name Bee;
extends AbstractEnemy;

@export var change_direction_time: float = 2.0;
@export var travel_speed: float = 175;
var _travel_direction: Vector2;
var _brownian_variance: Vector2 = Vector2(0.01, 0.01);
var _is_dying = false;

func _ready() -> void:
	_travel_direction = (
		Main.instance.player.global_position - global_position
	).normalized();

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var bee_to_player_vector = (
		Main.instance.player.global_position - global_position
	);
	_travel_direction = lerp(
		_travel_direction,
		bee_to_player_vector.normalized(),
		delta / change_direction_time,
	) + Vector2(randf_range(
		-_brownian_variance.x, _brownian_variance.x
	), randf_range(
		-_brownian_variance.y, _brownian_variance.y
	));

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

func gib_and_kill()->void:
	_is_dying = true;
	on_death.emit();
	await get_tree().create_timer(5).timeout;
	queue_free();
