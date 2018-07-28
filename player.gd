# Nathan Lovato's horizontal character movement code.
# Sources: 
#   YouTube: https://youtu.be/bSj7l25bdJ4
#   Pastebin: https://pastebin.com/bQAkRrWD
extends KinematicBody2D
 
var input_direction = 0
var direction = 0
 
var speed = 0
const MAX_SPEED = 400
const ACCELERATION = 1000
const DECELERATION = 2000
# Velocity is the X component of our motion vector.
var velocity = 0
 
func _ready():
    set_process(true)
 
func _process(delta):
    # INPUT
    # If the player pressed a key on the last tick,
    # We set the character's direction to the input
    if input_direction:
        direction = input_direction
   
    if Input.is_action_pressed("ui_left"):
        input_direction = -1
    elif Input.is_action_pressed("ui_right"):
        input_direction = 1
    else:
        input_direction = 0
   
   
    # MOVEMENT
    # If the player changed direction since last frame,
    # it means the character will turn around.
    # In that case, we lower the character's speed
    if input_direction == - direction:
        speed /= 3
 
    if input_direction:
        speed += ACCELERATION * delta
    else:
        speed -= DECELERATION * delta
 
    speed = clamp(speed, 0, MAX_SPEED)
   
    velocity = speed * delta * direction
    move_and_collide(Vector2(velocity, 0))