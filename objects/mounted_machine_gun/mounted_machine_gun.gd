class_name MountedMachineGun;
extends Node2D;

@export var is_firing = false;
@export var machine_gun_bullet: PackedScene = preload("res://objects/mounted_machine_gun/mounted_machine_gun_bullet.tscn");
@export var machine_gun_bullet_direction: Vector2 = Vector2.RIGHT;
@export_flags_2d_physics var machine_gun_bullet_collisison_mask;

var shoot_timer = 0.3;
var c_shoot_timer = 0;

func _process(delta: float) -> void:
	c_shoot_timer += delta;
	if is_firing and c_shoot_timer > shoot_timer:
		c_shoot_timer = 0;
		var m_gun_bullet: MountedMachineGunBullet = machine_gun_bullet.instantiate();
		Main.instance.add_child(m_gun_bullet);
		m_gun_bullet.global_position = $Marker2D.global_position;
		m_gun_bullet.movement_direction = machine_gun_bullet_direction;
		m_gun_bullet.collision_raycast.collision_mask = machine_gun_bullet_collisison_mask;
		print(m_gun_bullet.collision_raycast);
