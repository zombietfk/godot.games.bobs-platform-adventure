class_name FlyingImp;
extends CharacterBody2D;

enum FlyingImpState { SEEKING, PRE_ATTACK_PAUSE, ATTACKING };

var state: FlyingImpState = FlyingImpState.SEEKING;
var knockpack_impetus = Vector2(900, 900);
@export var seeking_speed = 200;
var attack_pause_length_timer = 1.0;
var c_attack_pause_length_timer = 0.0;
@export var attacking_speed = 800;
@export var attack_range = 125.0;
var attack_direction: Vector2;
@export var attacking_length_timer = 0.3;
var c_attacking_length_timer = 0.0;

var floating_displacement_timer = 0.0;
var floating_displacement_magnitude = 25;

signal on_death();

func _process(delta: float) -> void:
	match state:
		FlyingImpState.SEEKING:
			if global_position.distance_to(Main.instance.player.position) < attack_range:
				state = FlyingImpState.PRE_ATTACK_PAUSE;
				$Alert.visible = true;
			pass;
		FlyingImpState.PRE_ATTACK_PAUSE:
			c_attack_pause_length_timer += delta;
			if c_attack_pause_length_timer > attack_pause_length_timer:
				c_attack_pause_length_timer = 0;
				attack_direction = (Main.instance.player.position - global_position).normalized();
				$Alert.visible = false;
				state = FlyingImpState.ATTACKING;
		FlyingImpState.ATTACKING:
			c_attacking_length_timer += delta;
			if c_attacking_length_timer > attacking_length_timer:
				c_attacking_length_timer = 0;
				state = FlyingImpState.SEEKING;
	_process_attacks();
	
func _physics_process(delta: float) -> void:
	floating_displacement_timer += delta;
	position.y += sin(floating_displacement_timer) / 10;
	match state:
		FlyingImpState.SEEKING:
			velocity = (Main.instance.player.position - global_position).normalized() * seeking_speed;
		FlyingImpState.PRE_ATTACK_PAUSE:
			velocity = Vector2.ZERO;
		FlyingImpState.ATTACKING:
			velocity = attack_direction * attacking_speed;
	move_and_slide()

func _process_attacks() -> void:
	for collision in $ShapeCast2D.collision_result:
		var body = instance_from_id(collision["collider_id"]);
		if body is Player:
			body.damage(
				1,
				collision.normal,
				knockpack_impetus
			);

func gib_and_kill(gibs: int = 5) -> void:
	for i in gibs:
		Gib.spawn(global_position, -velocity);
	on_death.emit();
	queue_free();
