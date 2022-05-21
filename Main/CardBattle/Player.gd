extends KinematicBody2D


onready var enemyCard = get_parent().get_node("Enemy")
 
var velocity = Vector2(0,0)
const UP = Vector2(0,-1)

onready var speedLines = get_node("Speedlines")

onready var cardSpeed = get_parent().cardSpeed
onready var cardWindupSpeed = get_parent().cardWindUpSpeed

func _ready():
	get_parent().windup = true

func _physics_process(delta):
	if(get_parent().windup):
		velocity = self.global_position.direction_to(enemyCard.global_position) * -cardWindupSpeed
		speedLines.visible = true 
	else:	
		velocity = self.global_position.direction_to(enemyCard.global_position) * cardSpeed 	
	var collision = move_and_collide(velocity * delta)
	if collision: 
		queue_free()

