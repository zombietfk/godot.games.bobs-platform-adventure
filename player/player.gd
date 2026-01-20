class_name Player;
extends CharacterBody2D;

# CONSTANTS
const FLOOR_COLLISION_MASK = (1 << 7) | (1 << 8) | (1 << 9);
const FLOOR_CORRECTION_DISTANCE = 100;
const VELOCITY_X_MIN = 10;

# SETTINGS
@export var camera: Camera2D;
@export var player_heath_ui: PlayerHealthUI;
@export var lives_count_label_ui: Label;
@export var movement_state_machine: StateMachine;
@export var max_health = 3;
@export var current_health = 3;
@export var lives = 50;
@export var crush_check_raycast_up: RayCast2D;
@export var crush_check_raycast_down: RayCast2D;
@export var crush_check_raycast_left: RayCast2D;
@export var crush_check_raycast_right: RayCast2D;
@export var alert_notifcation: Sprite2D;

# SIGNALSs
@warning_ignore("unused_signal")
signal on_web_enter(web: Web);
@warning_ignore("unused_signal")
signal on_web_exit(web: Web);
@warning_ignore("unused_signal")
signal on_player_interaction();
@warning_ignore("unused_signal")
signal on_player_interaction_end();
signal on_take_damage(
	amount: int,
	from_direction: Vector2,
	knockback_strength: Vector2,
	knockback_duration_in_s: float,
);
signal on_kill();

# LIFECYCLE
func _process(_delta: float) -> void:
	if is_out_of_bounds() or current_health <= 0:
		on_kill.emit();
	if crush_check_raycast_up.is_colliding() and crush_check_raycast_down.is_colliding():
		on_kill.emit();
	if crush_check_raycast_left.is_colliding() and crush_check_raycast_right.is_colliding():
		on_kill.emit();
	lives_count_label_ui.text = var_to_str(lives);
	player_heath_ui.update_health_bar(current_health, max_health);

func _physics_process(_delta: float) -> void:
	move_and_slide();
	
# METHODS
func gib_and_kill() -> void:
	on_kill.emit();
	
func is_out_of_bounds() -> bool:
	return !Rect2(
		Main.level_instance.level_binding_box.position - Main.STANDARD_UNIT * Vector2.ONE,
		Main.level_instance.level_binding_box.size - Main.level_instance.level_binding_box.position + Main.STANDARD_UNIT * Vector2.ONE * 2,
	).has_point(global_position);
	
func damage(
	amount: int,
	from_direction: Vector2,
	knockback_strength: Vector2 = Vector2.ZERO,
	knockback_duration_in_s: float = 0.2,
) -> void:
	on_take_damage.emit(
		amount,
		from_direction,
		knockback_strength,
		knockback_duration_in_s
	);

func override_jump_flag() -> void:
	var movement_context = movement_state_machine.get_context("MovementContext") as PlayerMovementContext;
	movement_context.airborn_from_jump = false;

func set_alert_notification_visibility(show_alert = !alert_notifcation.visible):
	alert_notifcation.visible = show_alert;
