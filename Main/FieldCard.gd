extends TextureButton

onready var hand = get_tree().root.get_node('Board').get_node('Hand')
var card = load("res://Main/Card.tscn")

func card_place():
	SOUND.play('Place')
	var cardtest = card.instance()
	hand.add_child(cardtest)
	queue_free()

func _ready():
	pass

func _on_FieldCard_pressed():
	card_place()

