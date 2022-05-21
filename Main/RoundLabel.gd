extends Control

var prefix = 1

func _ready():
	pass

func _process(delta):
	$RoundContainer.get_node("RoundPrefix").text = str(prefix)
