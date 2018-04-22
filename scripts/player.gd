extends KinematicBody

var trusters = Vector3(0,0,0)
var speed = 24
var MOUSESPEED = 0.005

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	set_process_input(true)
	
func _process(delta):

	if Input.is_key_pressed(KEY_W) or Input.is_key_pressed(KEY_UP) or Input.is_mouse_button_pressed(1):
		translate(Vector3(0, 0, speed*delta))
	if Input.is_key_pressed(KEY_S) or Input.is_key_pressed(KEY_DOWN) or Input.is_mouse_button_pressed(2):
		translate(Vector3(0, 0, -speed*delta))
	if Input.is_key_pressed(KEY_A) or Input.is_key_pressed(KEY_LEFT):
		translate(Vector3(speed*delta, 0, 0))
	if Input.is_key_pressed(KEY_D) or Input.is_key_pressed(KEY_RIGHT):
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
