extends CanvasLayer

onready var roundConclusion = get_node("RoundConclusionText")

func _process(delta):
	roundConclusion.text = MAIN.gameStatus
