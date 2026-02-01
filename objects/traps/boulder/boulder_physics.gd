class_name BoulderPhysics;
extends RigidBody2D;

@export var gravity_rotation_enabled := false;
@export var gravity_rotation_speed := 0;
var _initial_gravity_scale: float;
var _gravity: Vector2;

func _on_body_entered(body: Node2D) -> void:
	if body.has_method('gib_and_kill'):
		body.gib_and_kill();

func _ready() -> void:
	if gravity_rotation_enabled:
		_initial_gravity_scale = gravity_scale;
		_gravity = ProjectSettings.get_setting(
			"physics/2d/default_gravity"
		) * ProjectSettings.get_setting(
			"physics/2d/default_gravity_vector"
		);
		gravity_scale = 0;

func _process(delta: float) -> void:
	if gravity_rotation_enabled:
		print(mass * _gravity * _initial_gravity_scale);
		apply_central_force(mass * _gravity * _initial_gravity_scale);
		if gravity_rotation_speed != 0:
			_gravity = _gravity.rotated(
				deg_to_rad(gravity_rotation_speed * delta)
			);
