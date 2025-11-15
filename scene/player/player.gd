extends CharacterBody2D
class_name Player

@export var max_hp = 20
@export var damage = 5
@export var speed = 50

var current_hp:
	set(_value):
		current_hp = _value
		PlayerManager.on_player_hp_change.emit(_value , max_hp)	#每次血量变动都触发一次信号
		if _value <= 0:
			PlayerManager.is_player_death.emit()	#检测当前血量，如果小于0则发送信号
		
var is_death = false

@onready var anime: AnimatedSprite2D = $Body/AnimatedSprite2D
@onready var body: Node2D = $Body
@onready var weapon: Node2D = $Body/Weapon


func _ready() -> void:
	GameManager.player = self
	PlayerManager.is_player_death.connect(is_player_death)
	current_hp = max_hp


func _physics_process(delta: float) -> void:
	if 	!is_death:
		#定义移动按键方向
		var dir = Vector2.ZERO
		dir.y = Input.get_axis("move_up" , "move_down")
		dir.x = Input.get_axis("move_left" , "move_right")
		#移动速度归一化
		if dir != Vector2.ZERO:
			velocity = dir.normalized() * speed
		else:
			velocity = Vector2.ZERO

		weapon_look_at()
		change_anime()	
		move_and_slide()

func change_anime():
	'''移动动画显示'''
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

func weapon_look_at():
	'''设置枪口方向'''
	var mouse_position = get_global_mouse_position()
	weapon.look_at(mouse_position)
	weapon.scale.y = 1
	weapon.z_index = 1
	#鼠标朝向两侧的枪口翻转
	if mouse_position.x > position.x and body.scale.x != 1:
		body.scale.x = 1
	elif mouse_position.x < position.x && body.scale.x != -1:
		body.scale.x = -1
	#在移动时由于左右移动贴图翻转，为使枪口朝向稳定打的补丁
	if velocity.x > 0:
		if mouse_position.x < position.x:
			weapon.scale.y = -1
	elif velocity.x < 0:
		if mouse_position.x > position.x:
			weapon.scale.y = -1
	elif velocity.y < 0:
		weapon.z_index = -1

func is_player_death():
	'''角色死亡'''
	is_death = true
	weapon.visible = false	#隐藏武器
	print('die')
	anime.play('die')


func signal_on_animated_sprite_2d_animation_finished() -> void:
	'''在播放完死亡动画后隐藏角色'''
	if anime.animation == 'die':
		self.visible = false
