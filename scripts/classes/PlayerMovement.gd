class_name PlayerMovement

var GRID_SIZE = 32

var body
var tween
var ray
var sprite
var inputs
var speed

var idle=true
var sprite_dir = 2

func _init(bod,twe,ra,spri,inp,spee):
	body=bod
	tween=twe
	ray=ra
	sprite=spri
	inputs=inp
	speed=spee

func direction_helper(new_pos, old_pos):
	if new_pos.x<old_pos.x:
		sprite.flip_h=true
		return 3
	if new_pos.x>old_pos.x:
		sprite.flip_h=false
		return 3
	if new_pos.y<old_pos.y:
		return 1
	if new_pos.y>old_pos.y:
		return 2

func handleInput():
	idle=false

func handleMovement():
	if !tween.is_active():
		if idle:
			match sprite_dir:
				1:
					sprite.play("UpIdle")
				2:
					sprite.play("Idle")
				3:
					sprite.play("SideIdle")

		idle=true
		var motion_vector = Vector2()
		for dir in inputs:
			if Input.is_action_pressed(dir):
				motion_vector += inputs[dir]
				break

		if motion_vector != Vector2():
			
			var new_position = body.position + motion_vector * GRID_SIZE

			sprite_dir = direction_helper(new_position,body.position)

			ray.cast_to=motion_vector * GRID_SIZE
			ray.force_raycast_update()
			if !ray.is_colliding():
				body.position=new_position
				sprite.position-=(motion_vector * GRID_SIZE)
				tween.interpolate_property( sprite, 'position', sprite.position, sprite.position+(motion_vector * GRID_SIZE), speed, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
				tween.start()
	else:
		match sprite_dir:
			1:
				sprite.play("Up")
			2:
				sprite.play("Down")
			3:
				sprite.play("Side")

	

