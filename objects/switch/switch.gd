class_name Switch;
extends Area2D;

# SETTINGS;
@export var has_timer = false;
@export var release_on_leave = false;
@export var is_persistant = false;
@export var persistant_trigger_name: String;

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
	switch_on(body);
	
func _on_body_exited(body) -> void:
	if release_on_leave:
		switch_off(body);

# LIFECYCLE
func _ready() -> void:
	if (
		is_persistant and
		Main.persistant_trigger_labels.find(persistant_trigger_name) != -1
	):
		switch_on(self);

func _process(delta: float) -> void:
	if has_timer and is_switched:
		c_switch_duration += delta;
		if c_switch_duration >= switch_duration:
			c_switch_duration = 0.0;
			switch_off(self);
		
# METHODS
func switch_on(by_body: Node2D):
	if !is_switched:
		$AnimatedSprite2D.play("switch_flipped");
		switch_flipped_on.emit(by_body);
		is_switched = true;
		if is_persistant:
			Main.persistant_trigger_labels.append(persistant_trigger_name);

func switch_off(by_body: Node2D):
	if is_switched:
		$AnimatedSprite2D.play("default");
		switch_flipped_off.emit(by_body);
		is_switched = false;
		if is_persistant:
			Main.persistant_trigger_labels.remove_at(
				Main.persistant_trigger_labels.find(persistant_trigger_name)
			);
