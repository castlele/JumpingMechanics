class_name Player extends CharacterBody2D

const MAX_JUMP_COUNT = 2

@export var preferences: PlayerPreferences = preload("res://nodes/player_preferences.tres")

@onready var animationManager = $AnimationManager
@onready var animatedSprite = $AnimatedSprite2D

@onready var move_speed = preferences.move_speed
@onready var jump_height = preferences.jump_height
@onready var jump_time_to_peak = preferences.jump_time_to_peak
@onready var jump_time_to_descent = preferences.jump_time_to_descent
@onready var is_double_jump_available = preferences.is_double_jump_available

@onready var jump_velocity = (2 * jump_height) / jump_time_to_peak * -1
@onready var jump_gravity = ((-2 * jump_height) / pow(jump_time_to_peak, 2.0)) * -1
@onready var fall_gravity = ((-2 * jump_height) / pow(jump_time_to_descent, 2.0)) * -1

var _jump_count = 1

# MARK: - Life Cycle

func _physics_process(delta: float):
    apply_gravity(delta)
    move(delta)
    jump(delta)

    move_and_slide()


func apply_gravity(delta: float):
    velocity.y += get_gravity() * delta

    if is_on_floor():
        _jump_count = 0


func move(delta: float):
    var direction = Input.get_axis("move_left", "move_right")

    velocity.x = move_speed * direction

    if direction:
        flip_horizontally(direction)
        animationManager.animate(animatedSprite, AnimationManager.AnimationState.RUN)
    else:
        animationManager.animate(animatedSprite, AnimationManager.AnimationState.IDLE)


func jump(delta: float):
    if not is_jump_available():
        return

    if Input.is_action_just_pressed("jump"):
        velocity.y = jump_velocity
        _jump_count += 1

# MARK: - Helper methods

func get_gravity() -> float:
    return jump_gravity if velocity.y < 0.0 else fall_gravity

func is_jump_available() -> bool:
    return is_on_floor() or (is_double_jump_available and _jump_count < MAX_JUMP_COUNT)


func flip_horizontally(direction: float):
    animatedSprite.flip_h = direction < 0
