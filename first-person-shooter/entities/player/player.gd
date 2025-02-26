extends CharacterBody3D

var speed:float
var camera_accel:float = 40

@export var walk_speed:float = 5.0
@export var run_speed:float = 40.0
@export var jump_velocity:float = 7.5
@export var mouse_sensitivity:float = 0.004
@export var joypad_sensitivity:float = 2.3
@export var joypad_deadzone:float = 0.1

@onready var head = $Head
@onready var camera = $Head/Camera3D
@onready var raycast = $Head/RayCast3D

func check_for_collision():
	var space = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(camera.global_position, camera.global_position - camera.global_transform.basis.z * 100)
	return space.intersect_ray(query)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		head.rotate_y(-event.relative.x * mouse_sensitivity)
		camera.rotate_x(-event.relative.y * mouse_sensitivity)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-40), deg_to_rad(60))
	
	if Input.is_action_just_pressed("shoot"):
		var collision = check_for_collision()
		if collision and collision.collider.is_in_group("enemy") and collision.collider.has_method("take_hit"):
			collision.collider.take_hit()

func _process(delta):
	var stick_right_x = Input.get_joy_axis(0, JOY_AXIS_RIGHT_X)
	var stick_right_y = Input.get_joy_axis(0, JOY_AXIS_RIGHT_Y)

	if abs(stick_right_x) > joypad_deadzone:
		head.rotate_y(-stick_right_x * joypad_sensitivity * delta)

	if abs(stick_right_y) > joypad_deadzone:
		camera.rotate_x(-stick_right_y * joypad_sensitivity * delta)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-40), deg_to_rad(60))

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity

	if Input.is_action_pressed("sprint"):
		speed = run_speed
	else:
		speed = walk_speed

	var input_dir := Input.get_vector("strife_left", "strife_right", "move_forward", "move_backward")
	var direction = (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	# Used for analog joystick speed compensation.
	var input_magnitude = input_dir.length()
	
	if direction:
		velocity.x = direction.x * speed * input_magnitude
		velocity.z = direction.z * speed * input_magnitude
	else:
		velocity.x = 0.0
		velocity.z = 0.0
	
	var collision = check_for_collision()
	if collision:
		SignalBus.emit_signal("target_changed", collision.collider)
	else:
		SignalBus.emit_signal("target_changed", null)
	
	move_and_slide()
