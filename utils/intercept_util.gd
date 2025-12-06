class_name InterceptUtil;

static func kinematic_body_intercept_2d(
	origin: Vector2,
	target: CharacterBody2D,
	speed: float,
	delta: float,
)->Vector2: 
	return (
		target.global_position
			+ (
				target.get_platform_velocity()
				* (
					target.global_position - origin
				).length() / speed * delta
			) + (
				Vector2(target.velocity.x, 0)
				* (
					target.global_position - origin
				).length() / speed * delta
			)
	)
