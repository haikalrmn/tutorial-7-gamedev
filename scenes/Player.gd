extends KinematicBody

export var walk_speed = 10
export var sprint_speed = 15
export var crouch_speed = 5
export var acceleration = 5
export var gravity = 0.98
export var jump_power = 30
export var mouse_sensitivity = 0.3

onready var head = $Head
onready var camera = $Head/Camera

var velocity = Vector3()
var camera_x_rotation = 0
var state = ''

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		head.rotate_y(deg2rad(-event.relative.x * mouse_sensitivity))

		var x_delta = event.relative.y * mouse_sensitivity
		if camera_x_rotation + x_delta > -90 and camera_x_rotation + x_delta < 90:
			camera.rotate_x(deg2rad(-x_delta))
			camera_x_rotation += x_delta

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _physics_process(delta):
	var head_basis = head.get_global_transform().basis
	var movement_vector = Vector3()
	var speed_used = walk_speed
	if Input.is_action_pressed("movement_forward"):
		movement_vector -= head_basis.z
	if Input.is_action_pressed("movement_backward"):
		movement_vector += head_basis.z
	if Input.is_action_pressed("movement_left"):
		movement_vector -= head_basis.x
	if Input.is_action_pressed("movement_right"):
		movement_vector += head_basis.x
	if Input.is_action_pressed("sprint"):
		state = 'sprint'
	if Input.is_action_just_released("sprint"):
		state = ''
	if Input.is_action_pressed("crouch"):
		if state != 'crouch':
			($CollisionShape.shape as CapsuleShape).height *= 0.5
			$Head.global_translation.y *= 0.5
		state = 'crouch'
	elif Input.is_action_just_released("crouch"):
		($CollisionShape.shape as CapsuleShape).height *= 2
		$Head.global_translation.y *= 2
		state = ''
	if state == 'sprint':
		speed_used = sprint_speed
	elif state == 'crouch':
		speed_used = crouch_speed
		
	movement_vector = movement_vector.normalized()
	
	velocity = velocity.linear_interpolate(movement_vector*speed_used,\
	 acceleration * delta)
	velocity.y -= gravity

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y += jump_power

	velocity = move_and_slide(velocity, Vector3.UP)

	# crouch debug
	#print(str($Head.global_translation.y) + " and " + str(($CollisionShape.shape as CapsuleShape).height) + ' and ' + state)
	
	# speed debug
	#print(velocity)
