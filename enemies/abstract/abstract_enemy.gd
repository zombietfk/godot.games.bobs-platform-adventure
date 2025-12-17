@abstract
class_name AbstractEnemy;
extends CharacterBody2D;

signal on_death();

func gib_and_kill(gibs: int = 5) -> void:
	for i in gibs:
		Gib.spawn(global_position, -velocity);
	on_death.emit();
	queue_free();
