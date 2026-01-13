class_name NegativeScaleUtil;
extends Node

# Util for setting negative x-values
# - Zombie+TFK

static func set_emulated_flip_to_negative_x_scale(
	body: CollisionObject2D,
	to_x_scale: float,
	base_rotation: float = 0,
):
	if to_x_scale == 0:
		return;
	if to_x_scale < 0:
		body.rotation = base_rotation + PI;
		body.scale = Vector2(abs(to_x_scale), -abs(body.scale.y));
		return;
	body.rotation = base_rotation;
	body.scale = Vector2(abs(to_x_scale), abs(body.scale.y));
	
static func lerp_emulated_flip_to_negative_x_scale(
	body: CollisionObject2D,
	inital_scale: Vector2,
	to_x_scale: float,
	base_rotation: float,
	t: float,
):
	var inital_scale_x = inital_scale.x;
	if inital_scale.y < 0:
		inital_scale_x = -inital_scale_x;
	var d = inital_scale_x - to_x_scale;
	var dt = d * t;
	var i = inital_scale_x - dt;
	NegativeScaleUtil.set_emulated_flip_to_negative_x_scale(
		body,
		i,
		base_rotation,
	);
