class_name CharcterAnimationChange

var state

func _init():
	state=changeState(1)

func getState():
	return state
	
func changeState(s):
	match s:
		1:
			state="Idle"
		2:
			state="UpIdle"
		3:
			state="Down"
		4:
			state="Up"
		5:
			state="Side"



