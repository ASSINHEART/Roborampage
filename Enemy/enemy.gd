extends CharacterBody3D
class_name Enemy

@onready var navigation_agent_3d: NavigationAgent3D = $NavigationAgent3D
@export var max_hitpoints := 100
@export var attack_range := 1.5
@export var aggro_range :=12.0 
@export var attack_damage := 10
@onready var animation_player: AnimationPlayer = $AnimationPlayer

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
var player
var provoked := false
var next_position
var direction
var hitpoints:int = max_hitpoints:
	set(value):
		hitpoints = value
		if hitpoints <= 0:
			queue_free()
		provoked = true
	get:
		return hitpoints
		

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")

func _process(delta: float) -> void:
	if provoked == true:
		navigation_agent_3d.target_position = player.global_position

func _physics_process(delta: float) -> void:
	var distance = global_position.distance_to(player.global_position)
	
	if distance <= aggro_range:
		provoked = true
	
	if provoked == true:
		if distance <= attack_range:
			animation_player.play("Attack")
		
		next_position = navigation_agent_3d.get_next_path_position()
		direction = global_position.direction_to(next_position)

	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	if provoked == true:
		look_at_target()
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	
	move_and_slide()

func look_at_target() ->void:
	var adjust_direction = direction
	adjust_direction.y = 0
	look_at(adjust_direction + global_position,Vector3.UP,true)

func attack() -> void:
	print("Enemy Attack")
	player.hitpoints -= attack_damage
	
