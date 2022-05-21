extends Control

var card = preload("res://Main/MenuCard.tscn")
onready var cardList = get_node("CardList").get_node("CardListGrid")
onready var deckBuildView = get_node("DeckBuildView").get_node("DeckGrid")
onready var deckLimitLabel = get_node("DeckLimitLabel")

var deckList = []
const deckLimit = 80
var deckCurrent = 0

func check_limit():
	var checkCurrent = 0
	
	for child in deckBuildView.get_children():
		checkCurrent = checkCurrent + MAIN.cardTypeLookup[child.cardType].effort
	deckCurrent = checkCurrent 

func _ready():
	for i in MAIN.cardTypes:
		if(i != 'Giga Chad'):
			var listCard = card.instance()
			listCard.type = 'Player'
			listCard.cardType = i
			cardList.add_child(listCard)
	for child in MAIN.deckList:
		var listCard = card.instance()
		listCard.type = 'Player'
		listCard.cardType = child
		deckBuildView.add_child(listCard)

func place_deck_card(cardName):
	if(deckCurrent + MAIN.cardTypeLookup[cardName].effort <= deckLimit):
		var listCard = card.instance()
		listCard.type = 'Player'
		listCard.cardType = cardName
		deckBuildView.add_child(listCard)

func remove_card(card):
	deckBuildView.remove_child(card)
	
func _process(delta):
	check_limit()
	deckLimitLabel.text = str(deckCurrent) + '/' + str(deckLimit)


func _on_ExitButton_pressed():
	SOUND.play('Confirm')
	get_tree().change_scene("res://Main/Menu.tscn")

func _on_SaveButton_pressed():
	SOUND.play('Confirm')
	MAIN.deckList = []
	for child in deckBuildView.get_children(): 
		MAIN.deckList.append(child.cardType)
	MAIN.maxDeckList = MAIN.deckList.size()
	yield(get_tree().create_timer(1), "timeout")
			
	get_tree().change_scene("res://Main/Menu.tscn")
