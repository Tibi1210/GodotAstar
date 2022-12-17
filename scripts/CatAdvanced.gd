extends KinematicBody2D

var GRID_SIZE = 32

onready var tween=$Tween
onready var _animated_sprite = $AnimatedSprite
onready var ray=$RayCast2D
onready var sprite=$AnimatedSprite

const inputs={
	'ui_up' : Vector2.UP,
	'ui_down': Vector2.DOWN,
	'ui_left': Vector2.LEFT,
	'ui_right': Vector2.RIGHT,
}


func _unhandled_input(_event):
	idle=false
	
var idle=true
func _physics_process(_delta):
	if !tween.is_active():
		if idle:
			_animated_sprite.play("idle")
		idle=true
		var motion_vector = Vector2()
		for dir in inputs:
			if Input.is_action_pressed(dir):
				motion_vector += inputs[dir]
				break

		if motion_vector != Vector2():	
			var new_position = position + motion_vector * GRID_SIZE
			if new_position.x<position.x:
				sprite.flip_h=true
			elif new_position.x>position.x:
				sprite.flip_h=false
			ray.cast_to=motion_vector * GRID_SIZE
			ray.force_raycast_update()
			if !ray.is_colliding():
				position=new_position
				sprite.position-=(motion_vector * GRID_SIZE)
				tween.interpolate_property( sprite, 'position', sprite.position, sprite.position+(motion_vector * GRID_SIZE), 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
				tween.start()
	else:
		_animated_sprite.play("move")
	

