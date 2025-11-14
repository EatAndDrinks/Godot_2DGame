extends Node2D
class_name BaseWeapon

@export  var bullet : PackedScene


@onready var shoot_point: Node2D = $ShootPoint

func shoot():
	var instance = bullet.instantiate() 
	instance.global_position = shoot_point.global_position
	instance.dir = global_position.direction_to(get_global_mouse_position())
	get_tree().root.add_child(instance)

func _process(delta: float) -> void:
	if Input.is_action_pressed("fire"):
		shoot()
