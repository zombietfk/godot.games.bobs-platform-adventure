class_name MountedMachineGun;
extends Node2D;

# SETTINGS
@export var is_firing = false;
@export var machine_gun_bullet: PackedScene = preload("res://objects/mounted_machine_gun/mounted_machine_gun_bullet.tscn");
@export var machine_gun_bullet_direction: Vector2 = Vector2.RIGHT;
@export var machine_gun_bullet_direction_variance = Vector2.ZERO;
@export_flags_2d_physics var machine_gun_bullet_collisison_mask;

#TIMERS
@export var shoot_timer = 0.1;
var c_shoot_timer = 0;

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
		Main.instance.player.player_interaction.disconnect(_on_player_interaction);
		Main.instance.player.player_interaction_end.disconnect(_on_player_interaction_end);
		Main.instance.player.set_alert_notification_visibility(false);
	
# LIFECYCLE
func _process(delta: float) -> void:
	c_shoot_timer += delta;
	if is_firing and c_shoot_timer > shoot_timer:
		print(33);
		c_shoot_timer = 0;
		var m_gun_bullet: MountedMachineGunBullet = machine_gun_bullet.instantiate();
		Main.instance.add_child(m_gun_bullet);
		m_gun_bullet.global_position = $Marker2D.global_position;
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
		);
		m_gun_bullet.collision_raycast.collision_mask = machine_gun_bullet_collisison_mask;
