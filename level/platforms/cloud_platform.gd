class_name Cloud_Disapearing_Platform;
extends CharacterBody2D

@export var floating_displacement = 25;
@export var on_land_displacement = 15;
@export var bounce_timer: float = 0.5;
@export var randomize_inital_displacement: bool = true;

var c_bounce_timer: float = bounce_timer;
var anchor_position: Vector2;
var displace_position: Vector2 = Vector2.ZERO;
var c_timer: float = 0;

func _ready() -> void:
	anchor_position = position;
	if randomize_inital_displacement:
		c_timer = randf() * PI;

func _physics_process(delta: float) -> void:
	if (is_checking_for_landing and
		Main.player.is_on_floor() and
		c_bounce_timer == bounce_timer
	):
		is_checking_for_landing = false;
		c_bounce_timer = 0.0;
	if c_bounce_timer < bounce_timer:
		c_bounce_timer += delta;
	if c_bounce_timer > bounce_timer:
		c_bounce_timer = bounce_timer;
	c_timer += delta;
	displace_position.y = (
		sin(c_timer) * floating_displacement +
		sin(c_bounce_timer / bounce_timer * PI) * on_land_displacement
	);
	position = anchor_position + displace_position;

var is_checking_for_landing = false;

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		is_checking_for_landing = true;

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is Player:
		is_checking_for_landing = false;
