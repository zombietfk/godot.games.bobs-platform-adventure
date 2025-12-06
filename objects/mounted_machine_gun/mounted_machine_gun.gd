class_name MountedMachineGun;
extends Node2D;

# SETTINGS
@export var is_firing = false;
@export var barrel_rotation_speed = 100;
@export var machine_gun_bullet: PackedScene = preload("res://objects/mounted_machine_gun/mounted_machine_gun_bullet.tscn");
@export var machine_gun_bullet_direction: Vector2 = Vector2.RIGHT;
@export var machine_gun_bullet_direction_variance = Vector2.ZERO;
@export var machine_gun_bullet_speed: float = 500;
@export_flags_2d_physics var machine_gun_bullet_collisison_mask;

# INTERNAL STATE
var barrel_rotation: float = 0;
var barrel_rotation_limit: float = 85;

#TIMERS
@export var shoot_timer: float = 0.1;
var c_shoot_timer: float = 0;
var barrel_rotation_reset_timer: float = 1.0;
var c_barrel_rotation_reset_timer: float = 0.0;

# TRIGGERS
func _on_player_interaction():
	is_firing = true;
	Main.instance.player.velocity = Vector2.ZERO;
	Main.instance.player.is_movement_disabled = true;
	
func _on_player_interaction_end():
	is_firing = false;
	Main.instance.player.velocity = Vector2.ZERO;
	Main.instance.player.is_movement_disabled = false;
	
func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		Main.instance.player.player_interaction.connect(_on_player_interaction);
		Main.instance.player.player_interaction_end.connect(_on_player_interaction_end);
		Main.instance.player.set_alert_notification_visibility(true);
	
func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		is_firing = false;
		Main.instance.player.is_movement_disabled = false;
		Main.instance.player.player_interaction.disconnect(_on_player_interaction);
		Main.instance.player.player_interaction_end.disconnect(_on_player_interaction_end);
		Main.instance.player.set_alert_notification_visibility(false);
	
# LIFECYCLE
func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("aim_down"):
		barrel_rotation += delta * barrel_rotation_speed;
	if Input.is_action_pressed("aim_up"):
		barrel_rotation -= delta * barrel_rotation_speed;
	barrel_rotation = clamp(barrel_rotation, -barrel_rotation_limit, barrel_rotation_limit)

func _process(delta: float) -> void:
	$BarrelPivot.rotation_degrees = barrel_rotation;
	c_shoot_timer += delta;
	if !is_firing:
		c_barrel_rotation_reset_timer += delta;
		if c_barrel_rotation_reset_timer >= barrel_rotation_reset_timer:
			barrel_rotation = 0.0;
		else:
			barrel_rotation = lerp(
				barrel_rotation,
				0.0,
				c_barrel_rotation_reset_timer / barrel_rotation_reset_timer
			);
	if is_firing and c_shoot_timer > shoot_timer:
		c_barrel_rotation_reset_timer = 0;
		c_shoot_timer = 0;
		var m_gun_bullet: MountedMachineGunBullet = machine_gun_bullet.instantiate();
		Main.instance.add_child(m_gun_bullet);
		m_gun_bullet.global_position = $BarrelPivot/Marker2D.global_position;
		m_gun_bullet.movement_direction = (
			machine_gun_bullet_direction +
			Vector2(
				randf_range(
					-machine_gun_bullet_direction_variance.x,
					machine_gun_bullet_direction_variance.x
				),
				randf_range(
					-machine_gun_bullet_direction_variance.y,
					machine_gun_bullet_direction_variance.y
				)
			)
		).rotated(deg_to_rad(barrel_rotation * scale.x));
		print(barrel_rotation);
		print(m_gun_bullet.movement_direction);
		m_gun_bullet.movement_speed = machine_gun_bullet_speed;
		m_gun_bullet.collision_raycast.collision_mask = machine_gun_bullet_collisison_mask;

func flip_gun_direction()->void:
	var target_scale = scale.x * -1;
	var original_scale = scale.x;
	var timer = 0;
	var timer_step = 0.02;
	while timer < 1:
		await get_tree().create_timer(timer_step).timeout;
		timer += timer_step;
		scale.x = lerp(original_scale, target_scale, timer);
	scale.x = original_scale * -1;
	machine_gun_bullet_direction *= -1;
