extends Node2D

const GRID_SIZE=32

onready var targetNode = get_node("/root/World/Target")
onready var aStarBody = get_node("/AstarBody")
onready var playerBody = get_node("/PlayerBody")
onready var aStarRay = get_node("/AstarBody/AstarRay")
onready var playerRay = get_node("/Player/PlayerRay")

class Nodes:
	var place
	var parent
	var gcost
	var hcost
	
	func _init(pos,par,g,h):
		place=pos
		parent=par
		gcost=g
		hcost=h
		
	func getFcost():
		return gcost+hcost
		
	func setGcost(g):
		gcost=g
	
	func setHcost(h):
		hcost=h

func getDistance(a, b):
		var dist = 0
		
		if (a.x < b.x):
			dist += b.x - a.x
		else:
			dist += a.x - b.x

		if (a.y < b.y):
			dist += b.y - a.y
		else:
			dist += a.y - b.y

		return dist;


func getNeighboursCollision(pos):
	var dir=[
	Vector2.UP,
	Vector2.DOWN,
	Vector2.LEFT,
	Vector2.RIGHT
]
	aStarBody.position=pos
	var neighbors=[]
	
	for d in dir:
		var vector_pos=d*GRID_SIZE
		aStarRay.cast_to=vector_pos
		aStarRay.force_raycast_update()
		if !aStarRay.is_colliding():
			neighbors.append(aStarBody.position + vector_pos)

	return neighbors


func getNeighbours(pos):
	var neighbors=[]
	neighbors.append(Vector2(pos.x-GRID_SIZE,pos.y))
	neighbors.append(Vector2(pos.x+GRID_SIZE,pos.y))
	neighbors.append(Vector2(pos.x,pos.y-GRID_SIZE))
	neighbors.append(Vector2(pos.x,pos.y+GRID_SIZE))
	return neighbors

const inputs={
	'up' : Vector2.UP,
	'down': Vector2.DOWN,
	'left': Vector2.LEFT,
	'right': Vector2.RIGHT,
	'step': null
}


func pathFind(start, stop):
	var next=null
	var open=[]
	var closed=[]
	
	var startNode=Nodes.new(start,null,0,getDistance(start,stop))
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
		#for step in getNeighbours(current.place):
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
				open.append(Nodes.new(step,current,newGcost,getDistance(step,stop)))
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


func _unhandled_input(event):
	for direction in inputs.keys():
		if event.is_action_pressed(direction):
			move(direction)

func move(direction):
	if inputs[direction]==null:
		position=pathFind(position,targetNode.position)
		print()
		print("Current Position: ", position)
		#print("Target Position: ", targetNode.position)
		#print("Distance to Target: ", getDistance(position,targetNode.position))
		print("All Neighbors of Current Position: ", getNeighbours(position))
		print("Available Neighbors of Current Position: ", getNeighboursCollision(position))
		print("Suggested Next Step: ", pathFind(position,targetNode.position))
	else:
		var vector_pos=inputs[direction]*GRID_SIZE
		playerRay.cast_to=vector_pos
		playerRay.force_raycast_update()
		if !playerRay.is_colliding():
			position += vector_pos
			print()
			print("Current Position: ", position)
			#print("Target Position: ", targetNode.position)
			#print("Distance to Target: ", getDistance(position,targetNode.position))
			print("All Neighbors of Current Position: ", getNeighbours(position))
			print("Available Neighbors of Current Position: ", getNeighboursCollision(position))
			print("Suggested Next Step: ", pathFind(position,targetNode.position))
		
		
#func _physics_process(delta):
	#position=pathFind(position,targetNode.position)
