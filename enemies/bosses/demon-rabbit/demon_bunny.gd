class_name DemonBunny;
extends CharacterBody2D

@export var slots : Slot;
@onready var pitchfork : DemonBunnyPitchfork = $Pitchfork;
@onready var pitchfork_origin_marker: Marker2D = $PitchforkOriginMarker;
@onready var sprite_body: AnimatedSprite2D = $Body;
