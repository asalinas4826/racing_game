extends Node

onready var p1 = get_node("Car")
onready var p2 = get_node("Car2")
# screen_size = 600x1024

func _ready():
	var player2Texture = preload("res://assets/blue_car.png")
	p2.get_node("Sprite").set_texture(player2Texture)
	
func _process(delta):
	if !p1.bouncing:
		move_player(delta, p1, "1")
	elif p1.bouncing:
		bounce_player(p1)
	if !p2.bouncing:
		move_player(delta, p2, "2")
	elif p2.bouncing:
		bounce_player(p2)
		
func move_player(delta, player, slot):
	var velocity = Vector2.ZERO
	
	if Input.is_action_pressed("p" + slot + "_up"):
		velocity.y -= 1
	if Input.is_action_pressed("p" + slot + "_down"):
		velocity.y += 1
	if Input.is_action_pressed("p" + slot + "_right"):
		velocity.x += 1
	if Input.is_action_pressed("p" + slot + "_left"):
		velocity.x -= 1
	
	if velocity.length() > 1:
		velocity = velocity.normalized()
	velocity *= player.speed * delta
	var collision = player.move_and_collide(velocity)
	if collision != null:
		toBounceState(collision, p1, velocity)
		bounce_player(player)

	
	if velocity.length() != 0:
		player.rotation = velocity.angle() + PI / 2
			
func bounce_player(player):
	var velocity = player.bounceVelocity
	var collision = player.move_and_collide(velocity)
	if collision != null:
		toBounceState(collision, player, velocity)

func toBounceState(collision, player, player_vel): # collider is the thing you're hitting
	var collider_v = collision.get_collider_velocity().limit_length(player_vel.length())
	var collider = collision.get_collider()
	print("player name: " + player.name + ", collider name: " + collider.name)
	print("player v x: " + str(player_vel.x) + ", player v y: "
		  + str(player_vel.y))
	print("collision v x: " + str(collider_v.x) + ", collision v y: "
		  + str(collider_v.y))
	
	# if x vectors are opposed, negate them
	# elif x vector is 0, add other x vector
	# else don't change them
	var new_collider_v = collider_v
	if new_collider_v.x == 0:
		new_collider_v.x = player_vel.x
		player_vel.x *= -1
	elif new_collider_v.x == -1 * player_vel.x:
		new_collider_v.x *= -1
		player_vel.x *= -1
		
	if new_collider_v.y == 0:
		new_collider_v.y = player_vel.y
		player_vel.y *= -1
	elif new_collider_v.y == -1 * player_vel.y:
		new_collider_v.y *= -1
		player_vel.y *= -1
		
	collider.bounceVelocity = new_collider_v
	collider.bouncing = true
	
	player.bounceVelocity = player_vel
	player.bouncing = true
	
	print("bounce player x: " + str(player_vel.x) + 
			", bounce player y: " + str(player_vel.y))
	print("bounce collider x: " + str(new_collider_v.x) + 
			", bounce collider y: " + str(new_collider_v.y) + "\n")
	# NOTE: will have to change this so that if you collide w/ non-player objects those objects don't 
	# bounce
	
	# NOTE: sometimes red car simply pushes blue car when any component vector opposes the other
	# bc red car collides w/ blue, blue collides w/ red, then red collides w/ blue again. 3 collisions
	# only happens sometimes, if it happens though and you keep holding them against each other, it chains
	
	# PROBLEM: collisions are detected twice bc red car detects collision and bounces, AND blue car detects collision
	
