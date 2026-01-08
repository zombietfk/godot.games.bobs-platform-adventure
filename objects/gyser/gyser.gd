class_name Gyser;
extends Node2D;

@onready var lift_effect_animation_player: AnimationPlayer = $LiftAreaAnimationPlayer;
@onready var water_effect_particle_effect: CPUParticles2D = $CPUParticles2D;
@onready var boost_area: Area2D = $LiftArea2D;
@export var shoot_water_every_x_seconds: float = 3.0;
@export var boost_power: float = 1000;
var _c_shoot_water_every_x_seconds: float;
var _is_water_shooting = false;

func _process(delta: float)->void:
	if _is_water_shooting:
		return;
	_c_shoot_water_every_x_seconds += delta;
	if _c_shoot_water_every_x_seconds > shoot_water_every_x_seconds:
		await _shoot_water();
		_c_shoot_water_every_x_seconds = 0;

func _physics_process(_delta: float) -> void:
	for body in boost_area.get_overlapping_bodies():
		if body is Player:
			body.velocity = lerp(body.velocity, Vector2.UP.rotated(rotation) * boost_power, 0.1);
			body.override_jump_flag();

func _shoot_water()->void:
	_is_water_shooting = true;
	water_effect_particle_effect.emitting = true;
	lift_effect_animation_player.play("ResizeLiftArea");
	await lift_effect_animation_player.animation_finished;
	lift_effect_animation_player.play("RESET");
	_is_water_shooting = false;
