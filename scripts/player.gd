extends KinematicBody

var trusters = Vector3(0,0,0)
var speed = 24
var MOUSESPEED = 0.005

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	set_process_input(true)
	
func _process(delta):

	if Input.is_key_pressed(KEY_W):
		translate(Vector3(0, 0, speed*delta))
	if Input.is_key_pressed(KEY_S):
		translate(Vector3(0, 0, -speed*delta))
	if Input.is_key_pressed(KEY_A):
		translate(Vector3(speed*delta, 0, 0))
	if Input.is_key_pressed(KEY_D):
		translate(Vector3(-speed*delta, 0, 0))

	if Input.is_key_pressed(KEY_E):
		translate(Vector3(0, speed*delta, 0))
	if Input.is_key_pressed(KEY_Q):
		translate(Vector3(0, -speed*delta, 0))
		
func activate_player():
	get_node("eyes").make_current()

func _input(event):
	if event is InputEventMouseMotion:
		rotation.y -= event.relative.x*MOUSESPEED
		rotation.x = clamp(rotation.x + event.relative.y*MOUSESPEED, deg2rad(-90), deg2rad(90))

	if Input.is_key_pressed(KEY_ESCAPE):
		get_tree().quit()
