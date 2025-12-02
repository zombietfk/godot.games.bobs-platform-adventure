class_name FallOnPassBelow;
extends Node2D;

@export var falling_node: Node2D;
@export var speed: float = 440;
@export var direction: Vector2 = Vector2.DOWN;
@export var fall_after: float = 0.4;
@export var before_fall_animation_label: String;

var is_falling = false;
var is_triggered = false;

func _process(_delta: float) -> void:
	if !is_falling and !is_triggered:
		var collision = $RayCast2D.get_collider();
		if collision is Player:
			is_triggered = true;
			$AnimationPlayer.play(before_fall_animation_label);
			await get_tree().create_timer(fall_after).timeout;
			$AnimationPlayer.stop();
			is_falling = true;

func _physics_process(delta: float) -> void:
	if is_falling:
		falling_node.position -= direction * speed * delta;
