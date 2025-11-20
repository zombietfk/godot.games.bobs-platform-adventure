class_name Spike;
extends Area2D;

# TRIGGERS
func _on_body_entered(body: Node2D) -> void:
	if body.has_method('gib_and_kill'):
		body.gib_and_kill();

# LIFECYCLE
func _ready() -> void:
	$AnimatedSprite2D.frame = randi_range(
		0,
		$AnimatedSprite2D.sprite_frames.get_frame_count(
			$AnimatedSprite2D.animation
		)
	);
	$AnimatedSprite2D.play();
