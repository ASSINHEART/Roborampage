extends Node3D

@export var weapon_1:Node3D
@export var weapon_2:Node3D

func _ready() -> void:
	equip(weapon_1)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("weapon_1"):
		equip(weapon_1)
	if event.is_action_pressed("weapon_2"):
		equip(weapon_2)
	if event.is_action_pressed("next_weapon"):
		equip(next_weapon())
	if event.is_action_pressed("last_weapon"):
		equip(last_weapon())
	
	
func equip(active_weapon:Node3D) -> void:
	for child in get_children():
		if child == active_weapon:
			child.visible = true
			child.set_process(true)
		else:
			child.visible = false
			child.set_process(false)


func next_weapon() -> Node3D:
	var index = get_current_index()
	index = wrapi(index + 1, 0, get_child_count())
	var next_weapon = get_child(index)
	return next_weapon

func last_weapon() ->Node3D:
	var index = get_current_index()
	index = wrapi(index + -1, 0, get_child_count())
	var last_weapon = get_child(index)
	return last_weapon

func get_current_index() -> int:
	for index in get_child_count():
		if get_child(index).visible == true:
			return index
	return 0
		
