extends Control

onready var description = get_node("Description")

func _process(delta):
	description.text = MAIN.abilityDisplay
