extends KinematicBody2D

const PlayerMovement = preload("res://scripts/PlayerMovement.gd")


onready var sprite = get_node("AnimatedSprite")
onready var ray = get_node("RayCast2D")
onready var tween = get_node("Tween")
onready var body = self


var inputs={
	'up' : Vector2.UP,
	'down': Vector2.DOWN,
	'left': Vector2.LEFT,
	'right': Vector2.RIGHT,
}


var moveHandler

func _ready():
	moveHandler=PlayerMovement.new(body,tween,ray,sprite,inputs)

func _unhandled_input(_event):
	moveHandler.handleInput()

func _physics_process(_delta):
	moveHandler.handleMovement()

