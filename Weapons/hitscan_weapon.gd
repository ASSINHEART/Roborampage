extends Node3D

@export var firerate := 14.0
@export var recoil := 0.05
@export var weapon_mesh: =Node3D
@export var weapon_damage := 10
@export var muzzle_flash: GPUParticles3D #跟随本体进入场景树直接实例化
@export var sparks: PackedScene #只进入内存没进入场景树,相当于保存了一个类的代码，但类要被实例化
@export var automatic: bool
@export var ammo_handler: AmmoHandler
@export var ammo_type: AmmoHandler.ammo_type

@onready var ray_cast_3d: RayCast3D = $RayCast3D
@onready var cool_down_timer: Timer = $CoolDownTimer
@onready var weapon_position: Vector3 = weapon_mesh.position
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if automatic == true:
		if Input.is_action_pressed("fire"):
			if cool_down_timer.is_stopped():
				shoot()
	else:
		if Input.is_action_just_pressed("fire"):
			if cool_down_timer.is_stopped():
				shoot()
	
	weapon_mesh.position = weapon_mesh.position.lerp(weapon_position,delta * 10.0)

func shoot() -> void:
	if ammo_handler.has_ammo(ammo_type):
		ammo_handler.use_ammo(ammo_type)
		cool_down_timer.start(1.0 / firerate)
		muzzle_flash.restart()
		
		weapon_mesh.position.z += recoil #后坐力
		
		var collider = ray_cast_3d.get_collider()
		if collider is Enemy:
			collider.hitpoints -= weapon_damage
		var spark = sparks.instantiate() #实例化
		add_child(spark) #实例化后加入场景树
		spark.global_position = ray_cast_3d.get_collision_point()
	
