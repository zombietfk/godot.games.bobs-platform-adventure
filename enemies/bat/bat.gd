class_name Bat
extends CharacterBody2D

@export var move_speed = 100;
@export var flapping_move_speed = 300;
@export var knockback_strength = Vector2.ONE * 500;
var is_awakening = false;
var is_awakened = false;
var flap_timer = 0.4;
var c_flap_timer = 0;
var flap_stength = 300;
var is_flapping = false;

func _physics_process(delta: float) -> void:
	if $RayCast2D.get_collider() is Player:
		awaken();
	if is_awakened:
		c_flap_timer += delta;
		if is_flapping:
			velocity.y -= flapping_move_speed * delta;
			if c_flap_timer > flap_timer:
				c_flap_timer = 0;
				is_flapping = false;
		else:
			velocity = (Main.instance.player.position - position).normalized() * move_speed
		if c_flap_timer > flap_timer:
			c_flap_timer = 0;
			is_flapping = true;
		move_and_slide();
		for n in $ShapeCast2D.get_collision_count():
			if $ShapeCast2D.get_collider(n) is Player:
				Main.instance.player.damage(
					1,
					$ShapeCast2D.get_collision_normal(n),
					knockback_strength
				);
				
func awaken() -> void:
	if is_awakening:
		return;
	is_awakening = true;
	$Hanging.play("waking_up");
	$AnimationPlayer.play("awaken");
	await get_tree().create_timer(2).timeout;
	is_awakened = true;
	$Flying.visible = true;
	$Hanging.visible = false;
	$AnimationPlayer.stop();

func gib_and_kill(gibs: int = 5) -> void:
	for i in gibs:
		Gib.spawn(global_position, -velocity);
	queue_free();
