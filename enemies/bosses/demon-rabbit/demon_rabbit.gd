class_name DemonRabbit
extends CharacterBody2D

# JUST IGNORE THIS SCRIPT, NOTHING TO SEE BUT EYE BLEEDING HORROR AHEAD

enum DemonRabbitState { IDLE, SUMMONING, POSTSUMMON, THROWING_PITCHFORK, STUNNED }

@export var jump_height: float;
@export var cast_jump_height: float;
@export var jump_timer = 3.0;
var c_jump_timer = 0.0;
var state: DemonRabbitState = DemonRabbitState.IDLE;
var death_count = 0;
var lives = 3;
@export var pitchfork_animator: AnimationPlayer;
var throw_pitchfork_timer = 3.0;
var c_throw_pitchfork_timer = 0.0;
var throw_pitchfork_return_timer = 6.0;
var is_holding_pitchfork = true;
var pitchfork_speed = 18;
var coroutine_processing_timer_duration = 0.02;
var summon_mirror_counter: Dictionary = {
	"to_summon": 2,
	"currently_summoned": 0,
	"destroyed": 0
};
var summon_timer: float = 3.0;
var c_summon_timer: float = 0;
@export var summoned_enemy_scene: PackedScene;
@export var mirror_scene: PackedScene;
@export var magic_spell_shot: PackedScene;
@export var mirror_spawn_locations: Array[Node2D];
var availiable_mirror_spawn_locations: Array[Node2D];
var mirror_summon_time = 5.0;
var bullet_hits_until_stunned = 10;
var is_in_bullet_hit_cooldown_period = false;
@export var platform_jump_locations: Array[Node2D];
var is_recovering = false;
var current_platform_jump_location: Node2D;
var is_being_destroyed = false;
var player: Player;

signal demon_rabbit_destroyed();

func _ready() -> void:
	availiable_mirror_spawn_locations = mirror_spawn_locations.duplicate();
	current_platform_jump_location = platform_jump_locations[0]

func _physics_process(delta: float) -> void:
	if is_on_floor() and state == DemonRabbitState.SUMMONING:
		c_jump_timer += delta;
		if c_jump_timer >= jump_timer: 
			c_jump_timer = 0;
			velocity.y = -jump_height;
	if is_holding_pitchfork and player != null:
		$Pitchfork.rotation = player.global_position.angle_to_point(
			$Pitchfork.global_position
		);
	if (global_position - current_platform_jump_location.global_position).length() < 32:
		$CollisionShape2D.disabled = false;
		if state == DemonRabbitState.IDLE and is_recovering:
			is_recovering = false;
			state = DemonRabbitState.SUMMONING;
	velocity += get_gravity() * delta;
	move_and_slide();
	
func _process(delta: float) -> void:
	match(state):
		DemonRabbitState.SUMMONING:
			$Body.play("default");
			_process_summoning_state(delta);
		DemonRabbitState.POSTSUMMON:
			$Body.play("default");
			_process_postsummon_state();
		DemonRabbitState.THROWING_PITCHFORK:
			$Body.play("angry");
			_process_throwing_pitchfork_state(delta);
		DemonRabbitState.STUNNED:
			$Body.play("stunned");
			recover_from_stun_and_reset();
		DemonRabbitState.IDLE:
			$Body.play("default");

func _process_throwing_pitchfork_state(delta: float) -> void:
	if is_holding_pitchfork:
		$ForceField.visible = true;
		$ForceField/StaticBody2D/CollisionShape2D.disabled = false;
		c_throw_pitchfork_timer += delta;
	else:
		$ForceField.visible = false;
		$ForceField/StaticBody2D/CollisionShape2D.disabled = true;
	if c_throw_pitchfork_timer > throw_pitchfork_timer:
		c_throw_pitchfork_timer = 0.0;
		throw_pitchfork_to_and_return(
			$Pitchfork.global_position,
			InterceptUtil.kinematic_body_intercept_2d(
				$Pitchfork.global_position,
				player,
				pitchfork_speed,
				coroutine_processing_timer_duration
			),
			2,
			throw_pitchfork_return_timer
		);

func _process_postsummon_state() -> void:
	if summon_mirror_counter.destroyed == summon_mirror_counter.to_summon:
		pitchfork_animator.stop();
		state = DemonRabbitState.THROWING_PITCHFORK;
		summon_mirror_counter.destroyed = 0;
		summon_mirror_counter.currently_summoned = 0;

func _process_summoning_state(delta: float) -> void:
	c_summon_timer += delta;
	if (
		c_summon_timer > summon_timer
		and summon_mirror_counter.currently_summoned < summon_mirror_counter.to_summon
	):
		summon_mirror_counter.currently_summoned += 1;
		c_summon_timer = 0;
		var spawn_location_index = randi_range(
			0,
			availiable_mirror_spawn_locations.size() - 1
		);
		var spawn_node = availiable_mirror_spawn_locations[
			spawn_location_index
		];
		availiable_mirror_spawn_locations.remove_at(spawn_location_index);
		await fire_spell_to_target(spawn_node);
		spawn_mirror_at_target(spawn_node);
	if summon_mirror_counter.currently_summoned >= summon_mirror_counter.to_summon:
		state = DemonRabbitState.POSTSUMMON;

func throw_pitchfork_to_and_return(
	from: Vector2,
	to: Vector2,
	outbound_duration: float,
	inbound_duration: float,
) -> void:
	is_holding_pitchfork = false;
	var c_duration = 0;
	$Pitchfork.rotation = player.global_position.angle_to_point(
		$Pitchfork.global_position
	);
	while c_duration < outbound_duration:
		$Pitchfork.global_position += (to - from).normalized() * pitchfork_speed;
		if $Pitchfork/RayCast2D.get_collider() == player:
			player.damage(1, (from - to).normalized(), Vector2(500,500));
		await get_tree().create_timer(coroutine_processing_timer_duration).timeout;
		if state != DemonRabbitState.THROWING_PITCHFORK:
			$Pitchfork/AnimationPlayer.stop();
			$Pitchfork.global_position = $PitchforkOriginMarker.global_position;
			is_holding_pitchfork = true;
			return;
		c_duration += coroutine_processing_timer_duration;
	c_duration = 0;
	$Pitchfork.rotation = global_position.angle_to_point(
		$Pitchfork.global_position
	);
	var current_pitchfork_position = $Pitchfork.global_position;
	while c_duration < inbound_duration:
		$Pitchfork/AnimationPlayer.play("spin_pitchfork");
		$Pitchfork.global_position = lerp(
			current_pitchfork_position,
			from,
			c_duration / inbound_duration
		);
		await get_tree().create_timer(coroutine_processing_timer_duration).timeout
		if state != DemonRabbitState.THROWING_PITCHFORK:
			$Pitchfork/AnimationPlayer.stop();
			$Pitchfork.global_position = $PitchforkOriginMarker.global_position;
			is_holding_pitchfork = true;
			return;		
		c_duration += coroutine_processing_timer_duration;
	$Pitchfork/AnimationPlayer.stop();
	is_holding_pitchfork = true;

func fire_spell_to_target(target: Node2D, travel_time: float = 2.0)->void:
	velocity.y = -cast_jump_height;
	pitchfork_animator.play("spin_pitchfork");
	await pitchfork_animator.animation_finished;
	var spell = magic_spell_shot.instantiate() as Node2D;
	Main.instance.level_instance.add_child(spell);
	spell.global_position = $Pitchfork.global_position;
	var inital_position = spell.global_position;
	var c_travel_time = 0;
	while c_travel_time < travel_time:
		await get_tree().create_timer(coroutine_processing_timer_duration).timeout;
		c_travel_time += coroutine_processing_timer_duration;
		spell.global_position = lerp(
			inital_position,
			target.global_position,
			c_travel_time / travel_time
		);
	spell.queue_free();

func spawn_mirror_at_target(target: Node2D)->void:
	var summoned_mirror = mirror_scene.instantiate() as Mirror;
	target.add_child(summoned_mirror);
	summoned_mirror.position = Vector2.UP * 64;
	summoned_mirror.scale = Vector2.ZERO;
	summoned_mirror.connect("on_shatter", Callable(func()->void:
		summon_mirror_counter.destroyed += 1;
	));
	increase_summoned_size_until(summoned_mirror, Vector2.ONE * 2);
	spawn_enemies_at_node_every_x(summoned_mirror, mirror_summon_time);

func spawn_enemies_at_node_every_x(node: Mirror, every_x: float)->void:
	await get_tree().create_timer(every_x).timeout;
	while node != null:
		var summoned_enemy = summoned_enemy_scene.instantiate() as FlyingImp;
		summoned_enemy.global_position = node.global_position;
		summoned_enemy.scale = Vector2.ZERO;
		node.connect("on_shatter", summoned_enemy.gib_and_kill);
		increase_summoned_size_until(summoned_enemy);
		Main.instance.level_instance.add_child(summoned_enemy);
		await get_tree().create_timer(every_x).timeout;
		
func increase_summoned_size_until(
	summon: Node2D,
	until_size: Vector2 = Vector2.ONE,
	duration: float = 1,
) -> void:
	var c_duration = 0.0;
	var inital_scale = summon.scale;
	while c_duration < duration:
		await get_tree().create_timer(coroutine_processing_timer_duration).timeout;
		if summon == null:
			return;
		c_duration += coroutine_processing_timer_duration;
		summon.scale = lerp(inital_scale, until_size, c_duration / duration);

func hit_by_bullet() -> void:
	if state == DemonRabbitState.THROWING_PITCHFORK and !is_in_bullet_hit_cooldown_period:
		is_in_bullet_hit_cooldown_period = true;
		$Body.modulate = Color(1.0, 1.0, 1.0, 1.0);
		await get_tree().create_timer(0.1).timeout;
		$Body.modulate = Color(1.0, 0.0, 0.0, 1.0);
		await get_tree().create_timer(0.2).timeout;
		is_in_bullet_hit_cooldown_period = false
		bullet_hits_until_stunned -= 1;
	if bullet_hits_until_stunned <= 0:
		$Pitchfork/AnimationPlayer.stop();
		$ForceField/StaticBody2D/CollisionShape2D.disabled = false;
		$Pitchfork.global_position = $PitchforkOriginMarker.global_position;
		state = DemonRabbitState.STUNNED;
		
func recover_from_stun_and_reset() -> void:
	$ForceField.visible = false;
	if is_recovering:
		return;
	death_count += 1;
	if death_count >= lives:
		destroy();
		return;
	is_recovering = true;
	await get_tree().create_timer(3.0).timeout;
	$ForceField.visible = true;
	state = DemonRabbitState.IDLE;
	await get_tree().create_timer(1.0).timeout;
	if platform_jump_locations.size() > 1:
		var target_platform_jump_location = current_platform_jump_location;
		while target_platform_jump_location == current_platform_jump_location: 
			target_platform_jump_location = platform_jump_locations.pick_random();
		current_platform_jump_location = target_platform_jump_location;
		if current_platform_jump_location.global_position.y > global_position.y:
			velocity.y = -500;
		else:
			velocity.y -= global_position.y - current_platform_jump_location.global_position.y + get_gravity().y * 0.5 + 128;
	$CollisionShape2D.disabled = true;
	summon_timer *= 0.8;
	summon_mirror_counter.to_summon *= 2;
	summon_mirror_counter.to_summon = clamp(summon_mirror_counter.to_summon, 0, 8);
	availiable_mirror_spawn_locations = mirror_spawn_locations.duplicate();
	throw_pitchfork_return_timer -= 1;
	throw_pitchfork_timer *= 0.8;
	mirror_summon_time -= 0.5;
	bullet_hits_until_stunned = 10;
	
func destroy()->void:
	if is_being_destroyed:
		return;
	is_being_destroyed = true;
	$ForceField.visible = false;
	scale.y *= -1;
	for i in 100:
		Gib.spawn(global_position, Vector2(sin((i * 4) / 50.0), -1));
		scale.x -= 0.01;
		scale.y += 0.01;
		await get_tree().create_timer(0.05).timeout;
	$CollisionShape2D.disabled = true;
	$ForceField/StaticBody2D/CollisionShape2D.disabled = true;
	await get_tree().create_timer(5).timeout;
	demon_rabbit_destroyed.emit();
	queue_free();

func _begin_attacking_on_battlezone_enter(body: Node2D) -> void:
	if body is Player:
		player = body;
		state = DemonRabbitState.SUMMONING;
