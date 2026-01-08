class_name PlayerMovementContext;
extends AbstractContext;

var slowed_by_webs: Array[Web] = [];
var movement_impetus: Vector2;
var knockback_impetus: Vector2;
var airborn_from_jump: bool = false;
@export var movement_speed: float = 34;
@export var max_movement_speed: float = 340;
@export var slowed_movement_speed_factor: float = 0.3;
@export var slowed_jump_impulse_factor: float = 0.6;
