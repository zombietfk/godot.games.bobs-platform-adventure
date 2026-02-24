class_name PlayerDeadState;
extends AbstractPlayerMovementState;

var _movement_context: PlayerMovementContext;

@export var respawn_grace_timer: Timer;
@export var respawn_timer: Timer;
@export var gib_count = 50;
@export var death_sounds: Array[AudioStreamPlayer];

func enter(_from: AbstractState)->void:
	Main.instance.music.stop();
	_movement_context = state_machine.get_context("MovementContext") as PlayerMovementContext;
	_movement_context.slowed_by_webs.clear();
	_play_death_sound();
	_kill();
	
func exit(_to: AbstractState)->void:
	Main.instance.music.play();
	body.visible = true;
	if respawn_timer.timeout.is_connected(_on_respawn_timeout):
		respawn_timer.timeout.disconnect(_on_respawn_timeout);
	if respawn_grace_timer.timeout.is_connected(_on_respawn_grace_timer_timeout):
		respawn_grace_timer.timeout.disconnect(_on_respawn_grace_timer_timeout);
	
func process(_delta: float)->void:
	pass;
	
func physics_process(_delta: float)->void:
	pass;

func _kill()->void:
	body.is_dead_flag = true;
	body.visible = false;
	body.velocity = Vector2.ZERO;
	_movement_context.movement_impetus = Vector2.ZERO;
	_movement_context.knockback_impetus = Vector2.ZERO;
	if !respawn_timer.timeout.is_connected(_on_respawn_timeout):
		respawn_timer.timeout.connect(_on_respawn_timeout);
	if !respawn_grace_timer.timeout.is_connected(_on_respawn_grace_timer_timeout):
		respawn_grace_timer.timeout.connect(_on_respawn_grace_timer_timeout);
	respawn_timer.start();
	for i in gib_count:
		Gib.spawn(body.global_position, -body.velocity);
	
func _on_respawn_grace_timer_timeout()->void:
	if body.get_parent() != Main.instance:
		body.reparent(Main.instance);
	body.rotation = 0;
	body.lives -= 1;
	if body.lives >= 0:
		Main.load_level();
	else:
		Main.reset_lives_load_checkpoint_level();
	body.current_health = body.max_health;
	body.damage(0, Vector2.ZERO);
	transition.emit("Grounded");
	await get_tree().create_timer(0.25).timeout;
	body.is_dead_flag = false;
	
func _on_respawn_timeout()->void:
	body.global_position = Main.instance.level_instance.spawn_locations[
		Main.instance.current_spawn_index
	].position;
	respawn_grace_timer.start();
	
func _play_death_sound()->void:
	var roll_lower_bond := 0;
	var roll_upper_bound := 100;
	var roll = randi_range(roll_lower_bond, roll_upper_bound);
	if roll <= 1:
		death_sounds[3].play();
	elif roll <= 33:
		death_sounds[0].play();
	elif roll <= 66:
		death_sounds[1].play();
	else:
		death_sounds[2].play();
