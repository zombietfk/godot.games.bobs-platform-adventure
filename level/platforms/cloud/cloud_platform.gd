class_name CloudPlatform;
extends CharacterBody2D;

# SETTINGS
@export var floating_displacement = 25;
@export var on_land_displacement = 15;
@export var randomize_inital_displacement: bool = true;
@export var enable_displacement = true;

# INTERNAL STATE
var anchor_position: Vector2;
var displace_position: Vector2 = Vector2.ZERO;

# TIMERS
@export var bounce_timer: float = 0.5;
var c_bounce_timer: float = bounce_timer;
var c_timer: float = 0;

# FLAGS
var is_player_standing_on_platform = false;
var is_landed_on_platform_one_shot_trigger = false;
var is_exited_from_platform_one_shot_trigger = false;

# SIGNALS
signal player_landed(platform: CloudPlatform);
signal player_exited(platform: CloudPlatform);

# TRIGGERS
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		if body.is_on_floor():
			is_player_standing_on_platform = true;
			is_landed_on_platform_one_shot_trigger = true;

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is Player and is_player_standing_on_platform:
		is_player_standing_on_platform = false;
		is_exited_from_platform_one_shot_trigger = true;

# LIFECYCLE
func _ready() -> void:
	anchor_position = position;
	if randomize_inital_displacement:
		c_timer = randf() * PI;

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
			player_landed.emit(self);
			is_landed_on_platform_one_shot_trigger = false;
			if c_bounce_timer == bounce_timer:
				c_bounce_timer = 0.0;

func _process_player_leave() -> void:
	if !is_player_standing_on_platform:
		if is_exited_from_platform_one_shot_trigger:
			player_exited.emit(self);
			is_exited_from_platform_one_shot_trigger = false;

func _physics_process(delta: float) -> void:
	_process_player_landed();
	_process_player_leave();
	if enable_displacement:
		_process_displacement(delta);
