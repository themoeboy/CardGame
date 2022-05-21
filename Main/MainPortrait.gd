extends Control

onready var drawCount = get_node("DrawCount")

func _process(delta):
	drawCount.text = str(MAIN.DRAW_COUNT)
