class_name AstarFinal

const MyNodes = preload("res://scripts/classes/MyNodes.gd")

const GRID_SIZE=32

var targetNode 
var aStarBody 
var playerBody
var sprite
var aStarRay 
var tween 

func _init(target,aBod,pBod,pSpr,aRay,twee):
	targetNode =target
	aStarBody =aBod
	playerBody=pBod
	sprite =pSpr
	aStarRay =aRay
	tween =twee


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


var idle=true
var sprite_dir = 2
var old_pos

func direction_helper(new_pos, current_pos):
	if new_pos.x<current_pos.x:
		sprite.flip_h=true
		return 3
	if new_pos.x>current_pos.x:
		sprite.flip_h=false
		return 3
	if new_pos.y<current_pos.y:
		return 1
	if new_pos.y>current_pos.y:
		return 2


func movement_handler():
	if !tween.is_active():
		if idle:
			match sprite_dir:
				1:
					sprite.play("UpIdle")
				2:
					sprite.play("Idle")
				3:
					sprite.play("SideIdle")

		idle=false
		
		var new_position=pathFind(playerBody.position,targetNode.position)
		if new_position==null:
			new_position=playerBody.position
		
		if new_position==playerBody.position:
			idle=true
			sprite_dir=2
		else:
			sprite_dir = direction_helper(new_position,playerBody.position)
		
		if !idle:
			old_pos=playerBody.position
			playerBody.position=new_position
			sprite.position-=playerBody.position-old_pos
			tween.interpolate_property( sprite, 'position', sprite.position, sprite.position+(playerBody.position-old_pos), 0.3, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
			tween.start()
	else:
		match sprite_dir:
			1:
				sprite.play("Up")
			2:
				sprite.play("Down")
			3:
				sprite.play("Side")


