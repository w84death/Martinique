extends KinematicBody

var trusters = Vector3(0,0,0)

func _ready():

	pass

func _process(delta):

	var thumb_x = Input.get_joy_axis(0, 0) * -1
	var thumb_y = Input.get_joy_axis(0, 1) * -1
	var thumb2_x = Input.get_joy_axis(0, 2)
	var thumb2_y = Input.get_joy_axis(0, 3)
	
	trusters = Vector3(thumb2_x, thumb_y, thumb2_y)
	self.move_and_collide(trusters)

func activate_player():
	get_node("eyes").make_current()
