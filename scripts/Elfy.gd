extends KinematicBody2D

const PlayerMovement = preload("res://scripts/classes/PlayerMovement.gd")
const PlayerInteract = preload("res://scripts/classes/PlayerInteract.gd")

onready var sprite = get_node("AnimatedSprite")
onready var ray = get_node("RayCast2D")
onready var tween = get_node("Tween")
onready var body = self

onready var interactableObjects = get_node("/root/World/InteractableObjects")

var inputs={
	'up' : Vector2.UP,
	'down': Vector2.DOWN,
	'left': Vector2.LEFT,
	'right': Vector2.RIGHT,
}

var speed=0.3

var moveHandler
var interactHandler

func _ready():
	moveHandler=PlayerMovement.new(body,tween,ray,sprite,inputs,speed)
	interactHandler=PlayerInteract.new(interactableObjects)


func _unhandled_input(event):
	if event.is_action_pressed("interact"):
		interactHandler.handle_interactions(position)
	else:
		moveHandler.handleInput()

func _physics_process(_delta):
	moveHandler.handleMovement()

