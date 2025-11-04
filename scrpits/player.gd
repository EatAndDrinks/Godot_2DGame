extends CharacterBody2D


@export var speed = 50

@onready var anime: AnimatedSprite2D = $Body/AnimatedSprite2D
@onready var body: Node2D = $Body


func _physics_process(delta: float) -> void:
	var dir = Vector2.ZERO
	dir.y = Input.get_axis("move_up" , "move_down")
	dir.x = Input.get_axis("move_left" , "move_right")
	
	if dir != Vector2.ZERO:
		velocity = dir.normalized() * speed
	else:
		velocity = Vector2.ZERO
		
	change_anime()	
	move_and_slide()

func change_anime():
	if velocity == Vector2.ZERO:
		anime.play("down_idle")
	elif velocity.x > 0:
		body.scale.x = 1
		anime.play("right_move")
	elif velocity.x < 0:
		body.scale.x = -1
		anime.play("right_move")
	elif velocity.y > 0:
		anime.play("down_move")
	elif velocity.y < 0:
		anime.play("up_move")
