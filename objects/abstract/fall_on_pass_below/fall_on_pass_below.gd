class_name FallOnPassBelow;
extends Node2D;

@export var falling_node: Node2D;
@export var speed: float = 440;
@export var direction: Vector2 = Vector2.DOWN;
@export var fall_after: float = 0.4;
@export var before_fall_animation_label: String;

var is_shaking = false;
var is_falling = false;

func _process(_delta: float) -> void:
	if !is_falling:
		var collision = $RayCast2D.get_collider();
		if collision is Player:
			$AnimationPlayer.play(before_fall_animation_label);
			await get_tree().create_timer(fall_after).timeout;
			$AnimationPlayer.play("RESET");
			is_falling = true;

func _physics_process(delta: float) -> void:
	if is_falling:
		falling_node.position -= direction * speed * delta;
