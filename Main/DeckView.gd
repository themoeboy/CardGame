extends Control

onready var cardGrid = get_node("CardGrid")
var card = preload("res://Main/Card.tscn")

func clear_grid():
	var cardList = cardGrid.get_children()
	for child in cardList:
		cardGrid.remove_child(child)
		
func _ready():
	clear_grid()
	for item in MAIN.deckList:
		var deckCard = card.instance()
		deckCard.type = 'Player'
		deckCard.cardType = item
		cardGrid.add_child(deckCard)
		
func _on_CloseButton_pressed():
	self.visible = false 
