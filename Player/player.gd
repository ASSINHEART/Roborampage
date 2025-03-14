extends CharacterBody3D
class_name Player

const SPEED = 5.0
var mouse_motion = Vector2.ZERO
@export var jump_height: float = 1.0
@export var fall_speed: float = 2.5
@export var max_hitpoints := 100

@onready var camera_pivot: Node3D = $CameraPivot
@onready var damage_animation_player: AnimationPlayer = $DamageTexture/DamageAnimationPlayer
@onready var game_over_menu: Control = $GameOverMenu

var hitpoints: int = max_hitpoints:
	set(value):
		if(value < hitpoints):
			damage_animation_player.stop(false)
			damage_animation_player.play()
		hitpoints = value
		damage_animation_player.play("TakeDamage")
		if(hitpoints <= 0):
			game_over_menu.game_over()
			
	get:
		return hitpoints


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _physics_process(delta: float) -> void:
	# Add the gravity.
	handle_camera_rotation()
	if not is_on_floor():
		if velocity.y >= 0:
			velocity += get_gravity() * delta 
		else:
			velocity += get_gravity() * delta * fall_speed

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = sqrt(-jump_height * 2.0 * get_gravity().y)
		
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		mouse_motion = -event.relative * 0.001
	if Input.is_action_just_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		 
func handle_camera_rotation() -> void:
	rotate_y(mouse_motion.x)
	camera_pivot.rotate_x(mouse_motion.y)
	camera_pivot.rotation_degrees.x = clampf(camera_pivot.rotation_degrees.x,-90.0,90.0)
	mouse_motion = Vector2.ZERO
	
