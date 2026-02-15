class_name ReelFace;
extends Node2D;

enum Values {
	UNDEFINED,
	PITCHFORK,
	BAT,
	ROCK,
	SPIKE,
	GUN
}

@onready var animation_player: AnimationPlayer = $AnimationPlayer;
@export var face_value: Values = Values.PITCHFORK;
@export var next_face: ReelFace;
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D;

func switch_to_next_face()->void:
	if next_face == null:
		_change_face_to(_get_random_face());
	else:
		_change_face_to(next_face.face_value)

func _get_random_face()->Values:
	var roll := randf();
	var threshholds := {
		Values.PITCHFORK : 0.225,
		Values.BAT: 0.225,
		Values.ROCK: 0.225,
		Values.SPIKE: 0.225,
		Values.GUN: 0.1,
	};
	var aggregate := 0.0;
	for key in threshholds:
		aggregate += threshholds[key];
		if roll < aggregate:
			return key;
	return Values.UNDEFINED;

func _change_face_to(face: Values)->void:
	face_value = face;
	match face:
		Values.PITCHFORK:
			sprite.animation = "pitchfork";
		Values.BAT:
			sprite.animation = "bat";
		Values.ROCK:
			sprite.animation = "rock";
		Values.SPIKE:
			sprite.animation = "spike";
		Values.GUN:
			sprite.animation = "gun";

func stop()->void:
	await _tween_animation_from_current_position_to(
		animation_player.get_animation(
			animation_player.current_animation
		).length * 0.5,
	);

func spin()->void:
	animation_player.play();

func _tween_animation_from_current_position_to(to: float)->void:
	animation_player.speed_scale = 0;
	var original_animation_position := animation_player.current_animation_position;
	var c_durtaion := 0.0;
	var durtaion := 1.0;
	while c_durtaion < durtaion:
		var seek_position = lerp(original_animation_position, to, c_durtaion / durtaion);
		animation_player.seek(seek_position, true);
		await get_tree().process_frame;
		c_durtaion += get_process_delta_time();
