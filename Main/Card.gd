extends TextureButton

onready var battleField = get_tree().root.get_node('Board').get_node('Battlefield')
onready var hand = get_tree().root.get_node('Board').get_node('Hand')
onready var cardName = get_node('Name')
onready var cardEffort = get_node('Effort')
onready var cardAttack = get_node('Attack')
onready var cardHealth = get_node('Health')
onready var cardStats = get_node('CardStats')
onready var cardHover = get_node('CardHover')
onready var cardView = get_node('CardView')


var isGigaChad = false 
var card = preload("res://Main/FieldCard.tscn")
var cardType 
var cardId 
var type = 'Player'
var reveal

func remove_hover():
	cardHover.visible = false 

func update_card():
	cardAttack.text = str(cardStats.attack)
	cardHealth.text = str(cardStats.health)
	
	if(cardStats.health < MAIN.cardTypeLookup[cardType].health):
		get_node("Health").add_color_override("font_color",  ColorN('lightCoral'))
		
	cardName.text = cardStats.cardName
	cardEffort.text = str(cardStats.effort)

func isReveal():
	return MAIN.enemyBattleReady and MAIN.playerReady

func card_place():
	if(type == 'Player'):
		if(get_parent().name != 'CardGrid'):
			if(get_parent().name == 'Hand' and battleField.get_child_count() < MAIN.MAX_BATTLEFIELD):
				self.remove_hover()
				get_parent().remove_child(self)
				battleField.add_child(self)
			else:
				self.remove_hover()
				get_parent().remove_child(self)
				hand.add_child(self)
		
func _ready():
	cardId = self.get_instance_id()
	cardAttack.text = str(MAIN.cardTypeLookup[cardType].attack)
	cardHealth.text = str(MAIN.cardTypeLookup[cardType].health)
	cardName.text = MAIN.cardTypeLookup[cardType].name
	cardEffort.text = str(MAIN.cardTypeLookup[cardType].effort)
	
	if(type == 'Player'):
		self.texture_normal = load(MAIN.cardTypeLookup[cardType].normal)
		self.texture_pressed =  load(MAIN.cardTypeLookup[cardType].pressed)
	elif (type == 'Enemy' and !isReveal()):
		cardAttack.visible = false 
		cardHealth.visible = false 
		cardName.visible = false 
		cardEffort.visible = false 
		self.texture_normal = load(MAIN.enemyCard.normal)
		self.texture_pressed =  load(MAIN.enemyCard.pressed)
	else:
		cardAttack.visible = true 
		cardHealth.visible = true
		cardName.visible = true
		cardEffort.visible = true
		if(isGigaChad):
			self.texture_normal = load(MAIN.cardTypeLookup[cardType].alternate)
			self.texture_pressed =  load(MAIN.cardTypeLookup[cardType].alternate)
		else:
			self.texture_normal = load(MAIN.cardTypeLookup[cardType].normal)
			self.texture_pressed =  load(MAIN.cardTypeLookup[cardType].pressed)

func handle_view():
	if(cardHover.visible):
		cardView.visible = true 
	else:
		cardView.visible = false

func _process(delta):
	update_card()
	if(type == 'Enemy' and isReveal() and get_parent().name != 'EnemyHand'):
		cardAttack.visible = true 
		cardHealth.visible = true
		cardName.visible = true
		cardEffort.visible = true
		if(isGigaChad):
			self.texture_normal = load(MAIN.cardTypeLookup[cardType].alternate)
			self.texture_pressed =  load(MAIN.cardTypeLookup[cardType].alternate)
		else:
			self.texture_normal = load(MAIN.cardTypeLookup[cardType].normal)
			self.texture_pressed =  load(MAIN.cardTypeLookup[cardType].pressed)
	if(type =='Enemy' and get_parent().name == 'EnemyHand'):
		cardAttack.visible = false 
		cardHealth.visible = false 
		cardName.visible = false 
		cardEffort.visible = false 
		self.texture_normal = load(MAIN.enemyCard.normal)
		self.texture_pressed = load(MAIN.enemyCard.pressed)
		
func _on_Card_pressed():
	SOUND.play('Place')
	card_place()

func _on_Card_mouse_entered():
	cardHover.visible = true 
	MAIN.abilityDisplay = MAIN.cardTypeLookup[cardType].ability
	
func _on_Card_mouse_exited():
	cardHover.visible = false
	MAIN.cardTypeLookup[cardType].normal
	MAIN.abilityDisplay = ''


