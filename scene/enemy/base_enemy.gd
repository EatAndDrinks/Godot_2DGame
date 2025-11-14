extends CharacterBody2D
class_name BaseEnemy

@export var max_hp = 10
@export var damage = 5
@export var speed := 50

var player_dead = false
var is_attack := false
var is_death := false
var current_target = null
var current_hp 

@onready var anim: AnimatedSprite2D = $Body/AnimatedSprite2D
@onready var body: Node2D = $Body


func _ready() -> void:
	current_hp = max_hp
	PlayerManager.is_player_death.connect(player_is_dead)

func _physics_process(delta: float) -> void:
	if player_dead:#如果player死亡则不再进行攻击
		is_attack = false
		
	if !is_attack and !is_death:
		'''默认的敌人寻路动画'''
		velocity = global_position.direction_to(GameManager.player.global_position) * speed 
		changeAnim()
		move_and_slide()
	attackAnime()

func changeAnim():
	if velocity == Vector2.ZERO:
		anim.play("idle")
	else :
		anim.play("walk")
	#转换方向
	if global_position.x > GameManager.player.global_position.x:
		body.scale.x = -1
	else :
		body.scale.x = 1


func attackAnime():
	'''攻击动画'''
	if is_attack :
		anim.play("attack")

func player_is_dead():
	'''主角死亡判断'''
	player_dead = true


func signal_on_attack_area_body_entered(body: Node2D) -> void:
	'''判断进入攻击区域'''
	if body is Player and !is_attack :
		current_target = body	#将攻击对象赋予current_target以便后续调用
		is_attack = true


func signal_on_attack_area_body_exited(body: Node2D) -> void:
	'''判定离开攻击区域'''
	if body is Player:
		is_attack = false
		current_target = null


func signal_on_animated_sprite_2d_animation_finished() -> void:
	'''检测正播放结束的动画是否是攻击，并在结束后造成伤害'''
	if anim.animation == 'attack':
		GameManager.damage(self , current_target)
