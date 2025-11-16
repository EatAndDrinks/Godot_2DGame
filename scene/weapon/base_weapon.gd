extends Node2D
class_name BaseWeapon


@export var bullet : PackedScene
@export var player : Player
@export var bullet_max := 30
@export var damage := 5
@export var weapon_rof = 0.2 		#枪械射速
@export var weapon_name = "默认武器"
@export var weapon_reload_time := 2.0 

var current_bullet = 0				#当前弹药
var current_rof_tick = 0			#射击计时器

@onready var weapon_sprite: Sprite2D = $WeaponSprite
@onready var shoot_point: Node2D = $ShootPoint

func _ready() -> void:
	'''赋值'''
	current_bullet = bullet_max
	'''链接信号'''
	PlayerManager.on_weapon_change.emit(self)
	PlayerManager.on_bullet_change.emit(current_bullet , bullet_max)#切换武器时切换文本


func _process(delta: float) -> void:
	if GameManager.player.is_death == false:
		current_rof_tick += delta
		if Input.is_action_pressed("fire") and current_rof_tick >= weapon_rof and current_bullet > 0:
			shoot()
			current_rof_tick = 0
			

func shoot():
	'''射击函数/同步UI'''
	var instance = bullet.instantiate() 
	instance.global_position = shoot_point.global_position
	instance.dir = global_position.direction_to(get_global_mouse_position())
	get_tree().root.add_child(instance)
	instance.current_weapon = self
	current_bullet -= 1			#减少子弹
	PlayerManager.on_bullet_change.emit(current_bullet , bullet_max)	#每次射击，触发子弹改变信号
	if current_bullet <= 0:
		reload()
	
func reload():
	'''换弹'''
	PlayerManager.on_weapon_reload.emit()
	await get_tree().create_timer(weapon_reload_time).timeout
	current_bullet = bullet_max
	PlayerManager.on_bullet_change.emit(current_bullet , bullet_max)	#每次射击，触发子弹改变信号
	
