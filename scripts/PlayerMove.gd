extends KinematicBody2D

var GRID_SIZE = 32

onready var tween=$Tween
onready var ray=$RayCast2D
onready var sprite=$Sprite

const inputs={
	'up' : Vector2.UP,
	'down': Vector2.DOWN,
	'left': Vector2.LEFT,
	'right': Vector2.RIGHT,
}

func _physics_process(_delta):
	if !tween.is_active():
		var motion_vector = Vector2()
		for dir in inputs:
			if Input.is_action_pressed(dir):
				motion_vector += inputs[dir]
				break

		if motion_vector != Vector2():	
			var new_position = position + motion_vector * GRID_SIZE
			ray.cast_to=motion_vector * GRID_SIZE
			ray.force_raycast_update()
			if !ray.is_colliding():
				position=new_position
				sprite.position-=(motion_vector * GRID_SIZE)
				tween.interpolate_property( sprite, 'position', sprite.position, sprite.position+(motion_vector * GRID_SIZE), 0.3, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
				tween.start()
				

