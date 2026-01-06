class_name Web;
extends Area2D;

@export var animated_sprite: AnimatedSprite2D;

func _ready()->void:
	animated_sprite.frame = randi_range(
		0,
		animated_sprite.sprite_frames.get_frame_count(
			animated_sprite.animation
		)
	);

func _on_body_entered(body: Node2D):
	if body.has_signal('on_web_enter'):
		body.on_web_enter.emit(self);

func _on_body_exited(body: Node2D):
	if body.has_signal('on_web_exit'):
		body.on_web_exit.emit(self);
