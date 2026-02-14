class_name BoulderPhysics;
extends RigidBody2D;

@export var gravitional_attractor_enabled := false;
@export var gravitional_attractor: Marker2D;
var _initial_gravity_scale: float;
var _gravity: Vector2;
var _environmental_gravity_magnitude: float;

func _on_body_entered(body: Node2D) -> void:
	if body.has_method('gib_and_kill'):
		body.gib_and_kill();

func _calculate_gravitonal_attrator_gravity() -> Vector2:
	return _environmental_gravity_magnitude * (
		gravitional_attractor.global_position - global_position
	).normalized();

func _ready() -> void:
	if gravitional_attractor_enabled:
		_initial_gravity_scale = gravity_scale;
		_environmental_gravity_magnitude = ProjectSettings.get_setting(
			"physics/2d/default_gravity"
		);
		_gravity = _calculate_gravitonal_attrator_gravity();
		gravity_scale = 0;

func _process(delta: float) -> void:
	if gravitional_attractor_enabled:
		_gravity = _calculate_gravitonal_attrator_gravity();
		apply_central_force(mass * _gravity * _initial_gravity_scale);
