extends Node2D

const MyNodes = preload("res://scripts/MyNodes.gd")

const GRID_SIZE=32

onready var targetNode = get_node("/root/World/PlayerEntity")
onready var aStarBody = get_node("AstarBody")
onready var playerBody = get_node("PlayerBody")
onready var aStarRay = get_node("AstarBody/AstarRay")
onready var tween = get_node("Tween")

func getDistance(a, b):
		return abs(b.x - a.x) + abs(b.y - a.y);

func getNeighboursCollision(pos):
	var dir=[
	Vector2.UP,
	Vector2.DOWN,
	Vector2.LEFT,
	Vector2.RIGHT
	]
	
	var neighbors=[]
	
	aStarBody.position=pos
	
	for d in dir:
		var vector_pos=d*GRID_SIZE
		aStarRay.cast_to=vector_pos
		aStarRay.force_raycast_update()
		if !aStarRay.is_colliding():
			neighbors.append(aStarBody.position + vector_pos)
	
	return neighbors

func pathFind(start, stop):
	var next=null
	var open=[]
	var closed=[]
	
	var startNode=MyNodes.new(start,null,0,getDistance(start,stop))
	open.append(startNode)
	
	while(!open.empty()):
		var current=open.front()
		
		for node in open:
			if(node.getFcost()<current.getFcost()||(node.getFcost()==current.getFcost()&&node.hcost<current.hcost)):
				current=node
		open.erase(current)
		closed.append(current)
		
		if (current.place==stop):
			next=pathSteps(startNode,current)
			return next.place
		
		for step in getNeighboursCollision(current.place):

			var inClosed=false
			for fail in closed:
				if(fail.place.x==step.x && fail.place.y==step.y):
					inClosed=true
			if(inClosed):
				continue
			
			var newGcost=current.gcost+getDistance(current.place,step)
			var inOpen = false
			var inOpenAt=0
			for fail in open:
				if(fail.place.x==step.x && fail.place.y==step.y):
					inOpen=true
				if(!inOpen):
					inOpenAt+=1
					
			if(!inOpen):
				open.append(MyNodes.new(step,current,newGcost,getDistance(step,stop)))
			if(inOpen&&newGcost<open[inOpenAt].gcost):
				open[inOpenAt].setGcost(newGcost)
				open[inOpenAt].setHcost(getDistance(step, stop))
				open[inOpenAt].parent = current
			
	return null

func pathSteps(start, stop):
	var steps=[]
	var current=stop
	while(current!=start):
		steps.append(current)
		current=current.parent
	if(steps.empty()):
		return stop
	return steps[steps.size()-1]


func _physics_process(_delta):
	if !tween.is_active():
		var new_position=pathFind(playerBody.position,targetNode.position)
		tween.interpolate_property ( playerBody, 'position', playerBody.position, new_position, 0.3, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		tween.start()


