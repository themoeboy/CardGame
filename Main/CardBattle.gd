extends Node2D

export var cardSpeed = 200
export var cardWindUpSpeed = 30
var windup 

onready var enemy =  get_node("Enemy")
onready var player = get_node("Player")
onready var enemySpeedLines = get_node("Enemy").get_node("Speedlines")
onready var playerSpeedLines = get_node("Player").get_node("Speedlines")

func _ready():
	enemySpeedLines.visible = false
	playerSpeedLines.visible = false
	


func _on_CrashAnimation_animation_finished():
	queue_free()
