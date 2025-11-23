class_name MountedMachineGun;
extends Node2D;

@export var is_firing = false;
@export var machine_gun_bullet: PackedScene = preload("res://objects/mounted_machine_gun/mounted_machine_gun_bullet.tscn");
@export var machine_gun_bullet_direction: Vector2 = Vector2.RIGHT;
@export_flags_2d_physics var machine_gun_bullet_collisison_mask;

func _process(_delta: float) -> void:
	if is_firing:
		await get_tree().create_timer(3).timeout;
		var m_gun_bullet: MountedMachineGunBullet = machine_gun_bullet.instantiate();
		Main.instance.add_child(m_gun_bullet);
		m_gun_bullet.global_position = global_position;
		m_gun_bullet.movement_direction = machine_gun_bullet_direction;
		m_gun_bullet.collision_raycast.collision_mask = machine_gun_bullet_collisison_mask;
		print(m_gun_bullet.collision_raycast);
