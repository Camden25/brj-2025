extends CharacterBody2D
class_name TopDownMovement


#---Basic Movement---#
@export var move_speed: int = 550
var move_dir: Vector2 = Vector2(0,0)
var prev_dir: Vector2 = Vector2(1,0)


#---Movement Abilities---#
@export var dash_enabled: bool = true
@export var can_dash: bool = true
@export var is_dashing: bool = false
@export var dash_speed: float = 2500
@export var dash_time: float = 0.13
@export var dash_cooldown: float = 0.4



func _process(_delta):
	get_input()


func _physics_process(_delta):
	if is_dashing == false:
		velocity = move_dir.normalized()*move_speed 
	else:
		velocity = prev_dir.normalized()*dash_speed
	
	move_and_slide()


func get_input():
	move_dir.x = int(Input.is_action_pressed("right")) - int(Input.is_action_pressed("left"))
	move_dir.y = int(Input.is_action_pressed("down")) - int(Input.is_action_pressed("up"))
	
	if is_dashing == false and move_dir != Vector2(0,0):
		prev_dir = move_dir
	
	if can_dash and Input.is_action_just_pressed("dash"):
		start_dash()


func start_dash():
	print("dash started")
	can_dash = false
	is_dashing = true
	await get_tree().create_timer(dash_time).timeout
	end_dash()


func end_dash():
	print("dash ended")
	is_dashing = false
	await get_tree().create_timer(dash_cooldown).timeout
	reset_dash()


func reset_dash():
	print("dash reset")
	can_dash = true
