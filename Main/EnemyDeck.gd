extends TextureButton

onready var deckCountLabel = get_node("DeckCountLabel")
onready var enemyDeckList = get_parent().get_node("EnemyDeckList")

func _process(delta):
	deckCountLabel.text = str(enemyDeckList.get_child_count()) + '/' + str(MAIN.maxEnemyDeckList)
	
func _on_EnemyDeck_mouse_entered():
	deckCountLabel.visible = true

func _on_EnemyDeck_mouse_exited():
	deckCountLabel.visible = false
