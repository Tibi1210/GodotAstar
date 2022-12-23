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
				print("interacted ", i)
