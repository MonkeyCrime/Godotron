# bullet.gd
class_name Bullet
extends EnemyBase

var bullet_format_string = "%s"


func _ready() -> void:
	unitType = Enums.UnitType.PLAYER_BULLET
	
	var bulletName = name.replace("@CharacterBody2D@", "Bullet_")
	set_name(bulletName)


func _physics_process(_delta: float) -> void:
	move_and_slide()
	var count = get_slide_collision_count()
	if count > 0:
		# Get rid of the bullet as it's hit something
		queue_free()

		# Let whatever the bullet has hit know its been hit
		for i in count:
			var collider = get_slide_collision(i).get_collider()
			#print(name, " (update) ", collider.name)
			if collider.is_in_group("Enemies"):
				collider.on_unit_hit(self)
				break
			# Electrodes are static objects and can't detect collisions themselves,
			# so we need to tell them they've been hit
			elif collider.is_in_group("Environment"):
				collider.on_unit_hit(owner)
				break


func onBulletExitedScreen() -> void:
	queue_free()
