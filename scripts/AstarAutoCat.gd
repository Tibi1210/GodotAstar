extends Node2D

const MyNodes = preload("res://scripts/classes/MyNodes.gd")
const AstarCompanion = preload("res://scripts/classes/AstarCompanion.gd")

const GRID_SIZE=32

onready var targetNode = get_node("/root/World/Elfy")
onready var aStarBody = get_node("AstarBody")
onready var playerBody = get_node("PlayerBody")
onready var sprite = get_node("PlayerBody/AnimatedSprite")
onready var aStarRay = get_node("AstarBody/AstarRay")
onready var tween = get_node("Tween")

var aStar

func _ready():
	aStar=AstarCompanion.new(targetNode,aStarBody,playerBody,sprite,aStarRay,tween)

func _physics_process(_delta):
	aStar.movement_handler()

