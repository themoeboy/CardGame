extends TextureButton

onready var deckGrid = get_tree().root.get_node('DeckBuildMenu').get_node('DeckBuildView').get_node('DeckGrid')
onready var cardName = get_node('Name')
onready var cardEffort = get_node('Effort')
onready var cardAttack = get_node('Attack')
onready var cardHealth = get_node('Health')
onready var cardStats = get_node('CardStats')
onready var cardHover = get_node('CardHover')
onready var deckBuild = get_tree().root.get_node('DeckBuildMenu')
onready var cardView = get_tree().root.get_node('DeckBuildMenu').get_node('CardView')

var cardType 
var cardId 
var type = 'Player'
var reveal

func remove_hover():
	cardHover.visible = false
	cardView.visible = false 

func update_card():
	cardAttack.text = str(cardStats.attack)
	cardHealth.text = str(cardStats.health)
	
	if(cardStats.health < MAIN.cardTypeLookup[cardType].health):
		get_node("Health").add_color_override("font_color",  ColorN('lightCoral'))
		
	cardName.text = cardStats.cardName
	cardEffort.text = str(cardStats.effort)

func card_place():
	SOUND.play('Place')
	if(get_parent().name == 'CardListGrid'):
		deckBuild.place_deck_card(cardType)
	else:
		deckBuild.remove_card(self)
		
func _ready():
	cardId = self.get_instance_id()
	cardAttack.text = str(MAIN.cardTypeLookup[cardType].attack)
	cardHealth.text = str(MAIN.cardTypeLookup[cardType].health)
	cardName.text = MAIN.cardTypeLookup[cardType].name
	cardEffort.text = str(MAIN.cardTypeLookup[cardType].effort)
	self.texture_normal = load(MAIN.cardTypeLookup[cardType].normal)
	self.texture_pressed =  load(MAIN.cardTypeLookup[cardType].pressed)
	
	cardAttack.visible = true 
	cardHealth.visible = true
	cardName.visible = true
	cardEffort.visible = true
	

func _on_Card_pressed():
	card_place()

func _on_Card_mouse_entered():
	cardHover.visible = true 
	cardView.visible = true
	MAIN.abilityDisplay = MAIN.cardTypeLookup[cardType].ability
	
func _on_Card_mouse_exited():
	cardHover.visible = false
	cardView.visible = false 
	MAIN.cardTypeLookup[cardType].normal
	MAIN.abilityDisplay = ''


