extends Node

const gun2 = preload("res://scene/weapon/Gun2.tscn")

signal is_player_death()		#player死亡信号
signal on_player_hp_change(current_hp , max_hp)	#血量改变信号	

signal on_bullet_change(current_bullet , bullet_max)
signal on_weapon_reload()
signal on_weapon_change(weapon : BaseWeapon)

func changeWeapon(weapon : BaseWeapon):
	'''切换武器'''
	var current_weapon = GameManager.player.weapon.get_child(0)
	if current_weapon:
		current_weapon.queue_free()
	GameManager.player.weapon.add_child(weapon)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		changeWeapon(gun2.instantiate())
