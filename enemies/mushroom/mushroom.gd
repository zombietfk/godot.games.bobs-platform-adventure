class_name Mushroom;
extends Node2D;

@export var poof_every_x_seconds: float = 2;
@export var poof_timer_inital_offset: float = 0;
@onready var idle_animation: AnimatedSprite2D = $IdleAnimatedSprite2D;
@onready var poof_animation: AnimatedSprite2D = $PoofAnimatedSprite2D;
@onready var spore_particles: CPUParticles2D = $PoofSpores;
@onready var spore_hit_area: Area2D = $Area2D;
@onready var spore_hit_area_animation: AnimationPlayer = $PoofSporeCollisionAreaAnim;
func _ready()->void:
	_poof(poof_timer_inital_offset);

func _poof(remaining_timer: float = 0)->void:
	while remaining_timer < poof_every_x_seconds:
		remaining_timer += get_process_delta_time();
		await get_tree().process_frame;
	idle_animation.visible = false;
	poof_animation.visible = true;
	poof_animation.play();
	spore_hit_area.monitoring = true;
	spore_particles.emitting = true;
	spore_hit_area_animation.play("poof");
	await poof_animation.animation_finished;
	await spore_hit_area_animation.animation_finished;
	spore_hit_area.monitoring = false;
	spore_hit_area_animation.stop();
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
