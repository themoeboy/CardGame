extends TextureButton

onready var hand = get_tree().root.get_node('Board').get_node('Hand')
onready var deckList = get_tree().root.get_node('Board').get_node('DeckView').get_node('CardGrid')

#func reset():
#	disabled = false

func can_draw():
	if(hand.get_child_count() <= MAIN.HAND_COUNT_MAX and MAIN.DRAW_COUNT > 0):
		return true
	else:
		return false
		
func _process(delta):
	if(MAIN.roundStatus == 'start' || MAIN.roundStatus == 'display' || MAIN.roundStatus == 'end'):
		disabled = true
	if (MAIN.roundStatus == 'ongoing' and can_draw()):
		disabled = false

func card_draw():
	randomize()
	var deckCount = deckList.get_child_count();
	if(deckCount > 0):
		var drawCard = deckList.get_child(randi()%deckCount)	
		deckList.remove_child(drawCard)
		hand.add_child(drawCard)
		MAIN.DRAW_COUNT = MAIN.DRAW_COUNT - 1 
		MAIN.current_draw = MAIN.current_draw + 1
	if(!can_draw() || deckCount == 0):
		disabled = true 

func _on_DrawButton_pressed():
	SOUND.play('Draw')
	card_draw()
