extends Control

@onready var hp_bar: ProgressBar = $HPControl/ProgressBar
@onready var bullet: Label = $"../WeaponControl/Bullet"
@onready var weapon_name: Label = $"../WeaponControl/WeaponName"
@onready var weapon_picture: TextureRect = $"../WeaponControl/WeaponPicture"

func _ready() -> void:
	PlayerManager.on_player_hp_change.connect(on_player_hp_change)
	PlayerManager.on_bullet_change.connect(on_bullet_change)
	PlayerManager.on_weapon_reload.connect(on_weapon_reload)
	PlayerManager.on_weapon_change.connect(on_weapon_change)
	
	
func on_player_hp_change(current_hp , max_hp):
	hp_bar.max_value = max_hp
	hp_bar.value = current_hp

func on_bullet_change(current , max):
	bullet.text = str(current) + "/" + str(max)
	
func on_weapon_reload():
	bullet.text = '换弹中...'

func on_weapon_change(weapon :BaseWeapon):
	weapon_name.text = weapon.weapon_name
	weapon_picture.texture = weapon.weapon_sprite.texture
