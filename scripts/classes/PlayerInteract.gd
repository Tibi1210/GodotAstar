class_name PlayerInteract

const GRID_SIZE = 32

const dir=[
		Vector2.UP,
		Vector2.DOWN,
		Vector2.LEFT,
		Vector2.RIGHT
		]
		
var objects
var position

func _init(interactableObjects):
	objects=interactableObjects.get_children()

func handle_interactions(pos):
	position=pos
	for i in objects:
		for d in dir:
			var neighbour=d*GRID_SIZE
			if i.position==position+neighbour:
				type_def(i)
				print("interacted ", i.name)

func type_def(current_object):
	match current_object.name[0]:
		"C":
			chest_handler(current_object)
		"D":
			door_handler(current_object)

	
func chest_handler(current_object):
	var sprite=current_object.get_node("AnimatedSprite")
	if sprite.animation=="closed":
		sprite.play("open")
	else:
		sprite.play("closed")

func door_handler(current_object):
	var sprite=current_object.get_node("AnimatedSprite")
	var collision=current_object.get_node("CollisionShape2D")
	if sprite.animation=="closed":
		sprite.play("open")
		collision.disabled=true
	else:
		sprite.play("closed")
		collision.disabled=false
