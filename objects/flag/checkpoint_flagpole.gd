class_name CheckpointFlagpole;
extends Node2D;

# SETTINGS
@export_file() var level_path: String;
@export var spawn_index: int;
@onready var flag_sound: AudioStreamPlayer = $AudioStreamPlayer;
@export var checkpoint_save_index: int;
@export var is_precompile_shaders_only_instance: bool = false;

signal prewarm_compelte();

func _ready() -> void:
	if is_precompile_shaders_only_instance:
		$Flag.confetti_particles_2d.amount = 5;
		$Flag.confetti_particles_2d.emitting = true;
		await get_tree().create_timer(0.1).timeout;
		$Flag.confetti_particles_2d.emitting = false;
		visible = false;
		prewarm_compelte.emit();

# TRIGGERS
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player and !$Flag.is_being_raised:
		CheckpointSaveManager.set_unlock_checkpoint(checkpoint_save_index);
		flag_sound.play();
		$Flag.raise_flag();
		Main.update_checkpoint(level_path, spawn_index);
		Main.update_spawn(level_path, spawn_index);
		body.lives = Main.DIFFICULTY.EASY;
