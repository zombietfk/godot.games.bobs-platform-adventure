class_name CloudPlatform;
extends AnimatableBody2D;

# SETTINGS
@export var floating_displacement = 25;
@export var on_land_displacement = 15;
@export var randomize_inital_displacement: bool = true;
@export var enable_displacement = true;
@export var start_disabled = false;

# INTERNAL STATE
var anchor_position: Vector2;
var displace_position: Vector2 = Vector2.ZERO;

# TIMERS
@export var bounce_timer: float = 0.5;
@onready var c_bounce_timer: float = bounce_timer;
var c_timer: float = 0;

# FLAGS
var is_player_standing_on_platform = false;
var is_landed_on_platform_one_shot_trigger = false;
var is_exited_from_platform_one_shot_trigger = false;

# SIGNALS
signal player_landed();
signal player_exited();

# LIFECYCLE
func _ready() -> void:
	anchor_position = position;
	if randomize_inital_displacement:
		c_timer = randf() * PI;
	if start_disabled:
		disable();

func _process_displacement(delta: float) -> void:
	if c_bounce_timer < bounce_timer:
		c_bounce_timer += delta;
	if c_bounce_timer > bounce_timer:
		c_bounce_timer = bounce_timer;
	c_timer += delta;
	displace_position.y = (
		sin(c_timer) * floating_displacement +
		sin(c_bounce_timer / bounce_timer * PI) * on_land_displacement
	);
	position = anchor_position + displace_position;

func _process_player_landed() -> void:
	if is_player_standing_on_platform:
		if is_landed_on_platform_one_shot_trigger:
			player_landed.emit();
			is_landed_on_platform_one_shot_trigger = false;
			if c_bounce_timer == bounce_timer:
				c_bounce_timer = 0.0;

func _process_player_leave() -> void:
	if !is_player_standing_on_platform:
		if is_exited_from_platform_one_shot_trigger:
			player_exited.emit();
			is_exited_from_platform_one_shot_trigger = false;

func _process_is_player_on_platform_flags() -> void:
	for collision in $ShapeCast2D.collision_result:
		var collider = instance_from_id(collision["collider_id"])
		if collider is Player:
			if collider.is_on_floor() and !is_player_standing_on_platform:
				is_player_standing_on_platform = true;
				is_landed_on_platform_one_shot_trigger = true;
				player_landed.emit();
			elif !collider.is_on_floor() and is_player_standing_on_platform:
				is_player_standing_on_platform = false;
				is_exited_from_platform_one_shot_trigger = true;
				player_exited.emit();

func _physics_process(delta: float) -> void:
	_process_player_landed();
	_process_player_leave();
	if enable_displacement:
		_process_displacement(delta);
	_process_is_player_on_platform_flags();

func disable() -> void:
	visible = false;
	process_mode = Node.PROCESS_MODE_DISABLED;
	for child in get_children():
		if child is CollisionShape2D:
			child.disabled = true;

func enable() -> void:
	visible = true;
	process_mode = Node.PROCESS_MODE_INHERIT;
	for child in get_children():
		if child is CollisionShape2D:
			child.disabled = false;
