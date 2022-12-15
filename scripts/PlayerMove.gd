extends KinematicBody2D

const GRID_SIZE=32

onready var ray=$RayCast2D

const inputs={
	'up' : Vector2.UP,
	'down': Vector2.DOWN,
	'left': Vector2.LEFT,
	'right': Vector2.RIGHT,
	'step': null
}

func _unhandled_input(event):
	for direction in inputs.keys():
		if event.is_action_pressed(direction):
			move(direction)

func move(direction):
	if !inputs[direction]==null:
		var vector_pos=inputs[direction]*GRID_SIZE
		ray.cast_to=vector_pos
		ray.force_raycast_update()
		if !ray.is_colliding():
			position += vector_pos

		
#func _physics_process(delta):
	#position=pathFind(position,targetNode.position)
