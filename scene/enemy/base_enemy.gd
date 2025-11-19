extends CharacterBody2D
class_name BaseEnemy

@export var max_hp = 10
@export var damage = 5
@export var speed := 50
@export var damage_float : PackedScene

var player_dead = false
var is_attack := false
var is_death := false
var current_target = null
var current_hp:
	set(value):
		if current_hp and current_hp - value != 0:
			on_damaged.emit(value - current_hp)		#每次生命值变化时候发送收到伤害信号
		current_hp = value
		if current_hp <= 0:
			on_death.emit()
			is_death = true

signal on_death
signal on_damaged(damaged)

@onready var anim: AnimatedSprite2D = $Body/AnimatedSprite2D
@onready var body: Node2D = $Body
@onready var coll: CollisionShape2D = $CollisionShape2D
@onready var shadow: Sprite2D = $Shadow


func _ready() -> void:
	EnemyManager.enemies.append(self)			#添加自己到刷怪队列
	current_hp = max_hp
	PlayerManager.is_player_death.connect(player_is_dead)
	on_death.connect(death)
	on_damaged.connect(on_damaged_float)

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

func _exit_tree() -> void:
	'''怪物死亡时触发信号'''
	EnemyManager.enemies.erase(self)
	EnemyManager.on_enemy_death.emit()
	EnemyManager.check_enemy()
	
func death():
	coll.call_deferred('set_disabled' , true)		#将碰撞体设为false，防止死亡后阻挡子弹
	shadow.hide()
	anim.play("death")
	
func on_damaged_float(damaged):
	var damage_text : Node2D = damage_float.instantiate()	#实例化节点
	damage_text.set_damage(damaged)							#设置伤害数值
	add_child(damage_text)									#添加到场景树中
	damage_text.global_position = global_position + Vector2.UP * 20	#设置偏移（无伤大雅）

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

func _on_animated_sprite_2d_frame_changed() -> void:
	'''检测正播放结束的动画是否是攻击，并在第4帧造成伤害'''
	if anim.animation == 'attack' and anim.frame == 4:
		GameManager.damage(self , current_target)
		
func _on_animated_sprite_2d_animation_finished() -> void:
	if anim.animation == 'death':
		queue_free()
