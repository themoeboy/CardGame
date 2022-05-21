extends KinematicBody2D


onready var playerCard = get_parent().get_node("Player")
onready var windupTimer = get_parent().get_node("WindupTimer")
onready var crashAnimation = get_parent().get_node("CrashAnimation")


var velocity = Vector2(0,0)
const UP = Vector2(0,-1)

onready var cardSpeed = get_parent().cardSpeed
onready var cardWindupSpeed = get_parent().cardWindUpSpeed

onready var speedLines = get_node("Speedlines")

func _ready():
	get_parent().windup = true
	windupTimer.start() 

func _physics_process(delta):
	if(get_parent().windup):
		velocity = self.global_position.direction_to(playerCard.global_position) * -cardWindupSpeed 
		speedLines.visible = true 
	else:	
		velocity = self.global_position.direction_to(playerCard.global_position) * cardSpeed 
	var collision = move_and_collide(velocity * delta)
	if collision: 
		queue_free()
		crashAnimation.visible = true
		crashAnimation.playing = true


func _on_WindupTimer_timeout():
	get_parent().windup = false

