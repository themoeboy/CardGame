extends TextureButton

var testPost = Vector2(250,264)
var card = preload("res://Main/Card.tscn")
onready var drawTimer = get_node("DrawTimer")
onready var deckView = get_parent().get_node("DeckView")
onready var deckCountLabel = get_node("DeckCountLabel")
onready var deckList = get_tree().root.get_node('Board').get_node('DeckView').get_node('CardGrid')
const DRAW_COUNT_MAX = 7
var current_draw = 0
var loadDeck = 0
onready var hand = get_parent().get_node('Hand')

func demo_load():
	while(loadDeck < MAIN.maxDeckList):
		var deckCard = card.instance()
		randomize()
		deckCard.type = 'Player'
		deckCard.cardType = MAIN.cardTypes[randi()%MAIN.cardTypes.size()]
		MAIN.deckList.append(deckCard)
		loadDeck = loadDeck + 1
		

func _process(delta):
	deckCountLabel.text = str(deckList.get_child_count()) + '/' + str(MAIN.maxDeckList)

func card_draw():
	randomize()
	var drawCard = MAIN.deckList[randi()%MAIN.deckList.size()]
	hand.add_child(drawCard)
	current_draw = current_draw + 1	

func _on_Deck_pressed():
#	drawTimer.start()
	deckView.visible = true 
	
func _on_DrawTimer_timeout():
	if(current_draw < DRAW_COUNT_MAX):
		card_draw()
	else:
		current_draw = 0
		drawTimer.stop()


func _on_Deck_mouse_entered():
	deckCountLabel.visible = true

func _on_Deck_mouse_exited():
	deckCountLabel.visible = false
