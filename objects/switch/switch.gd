class_name Switch;
extends Area2D;

# SETTINGS;
@export var has_timer = false;
@export var release_on_leave = false;

# INTERNAL STATE
var is_switched = false;

# TIMERS
@export var switch_duration = 0.0;
var c_switch_duration = 0.0;

# SIGNALS
signal switch_flipped_on(by: Node2D);
signal switch_flipped_off(by: Node2D);

# TRIGGERS
func _on_body_entered(body) -> void:
	if !is_switched:
		$AnimatedSprite2D.play("switch_flipped");
		switch_flipped_on.emit(body);
		is_switched = true;

func _on_body_exited(body) -> void:
	if is_switched and release_on_leave:
		$AnimatedSprite2D.play("default");
		switch_flipped_off.emit(body);
		is_switched = false;

# LIFECYCLE
func _process(delta: float) -> void:
	if has_timer and is_switched:
		c_switch_duration += delta;
		if c_switch_duration >= switch_duration:
			c_switch_duration = 0.0;
			$AnimatedSprite2D.play("default");
			switch_flipped_off.emit(self);
		
