extends Node2D
class_name BaseBullet

@export var speed := 200
@export var dir := Vector2.ZERO

func _ready() -> void:
	look_at(get_global_mouse_position())

func _physics_process(delta: float) -> void:
	position += dir * speed * delta
	


func signal_on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
