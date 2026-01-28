class_name Mushroom;
extends Node2D;

@export var poof_every_x_seconds: float = 2;
@export var poof_timer_inital_offset: float = 0;
@export var spore_scene: PackedScene;
@export var spore_count := 4;
@export var spore_release_arc_in_degrees := 35.0;
@export var spore_release_force := 172.0;
@onready var idle_animation: AnimatedSprite2D = $IdleAnimatedSprite2D;
@onready var poof_animation: AnimatedSprite2D = $PoofAnimatedSprite2D;
@onready var spore_particles: CPUParticles2D = $PoofSpores;

func _ready()->void:
	_poof(poof_timer_inital_offset);

func _poof(remaining_timer: float = 0)->void:
	while remaining_timer < poof_every_x_seconds:
		remaining_timer += get_process_delta_time();
		await get_tree().process_frame;
	idle_animation.visible = false;
	poof_animation.visible = true;
	poof_animation.play();
	spore_particles.emitting = true;
	var spore_release_rotation_degrees := -spore_release_arc_in_degrees;
	var arc_step := (spore_release_arc_in_degrees / spore_count) * 2;
	spore_release_rotation_degrees += arc_step / 2;
	for n in spore_count:
		var spore = spore_scene.instantiate() as RigidBody2D;
		spore.global_position = global_position;
		Main.instance.level_instance.add_child(spore);
		spore.apply_impulse(Vector2.UP.rotated(rotation).rotated(deg_to_rad(spore_release_rotation_degrees)) * spore_release_force);
		spore_release_rotation_degrees += arc_step;
	await poof_animation.animation_finished;
	idle_animation.visible = true;
	poof_animation.visible = false;
	_poof();
	
func _on_spore_hit(body: Node2D)->void:
	if body is Player:
		body.damage(
			1,
			global_position - body.global_position,
			Vector2.ZERO
		);
