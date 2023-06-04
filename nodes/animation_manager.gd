class_name AnimationManager extends Node2D

enum AnimationState { IDLE, RUN }


func animate(sprite: AnimatedSprite2D, state: AnimationState):
    var str_state_name = AnimationState.keys()[state].to_lower()
    sprite.play(str_state_name)
