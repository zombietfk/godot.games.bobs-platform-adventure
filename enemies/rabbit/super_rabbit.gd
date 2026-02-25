class_name SuperRabbit;
extends Node2D;

@export var entrance_sound: AudioStreamPlayer;
@export var hit_sound: AudioStreamPlayer;
@export var hit_particles_effect: CPUParticles2D;
@export var superbunny_body: AnimatedSprite2D;

func _ready()->void:
	entrance_sound.play(1.5);
	
func _on_hit_demon_bunny(body: Node2D)->void:
	if body is DemonBunny:
		superbunny_body.visible = false;
		hit_sound.play();
		hit_particles_effect.emitting = true;
		await hit_particles_effect.finished;
		queue_free();
		body.take_damage();
