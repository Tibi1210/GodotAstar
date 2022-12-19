class_name MyNodes
	
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
