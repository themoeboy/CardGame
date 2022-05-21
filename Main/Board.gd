extends Node2D

var cardBack = preload("res://Main/CardBack.tscn")
var card = preload("res://Main/Card.tscn")

onready var enemyHand = get_node('EnemyHand')
onready var playerHand = get_node('Hand')
onready var enemyDrawTimer = get_node('EnemyDrawTimer')
onready var enemySelectTimer = get_node('EnemySelectTimer')
onready var enemyBattleField = get_node("EnemyBattlefield")
onready var playerBattleField = get_node("Battlefield")
onready var combatMockTimer = get_node("CombatMockTimer")
onready var battleDelayTimer = get_node("BattleDelayTimer")
onready var roundLabel = get_node("RoundLabel")
onready var readyButton = get_node("ReadyButton")
onready var roundTransitionTimer = get_node("RoundTransitionTimer")
onready var deckList = get_tree().root.get_node('Board').get_node('DeckView').get_node('CardGrid')
onready var roundConclusion = get_node("RoundConclusion").get_node("RoundConclusionText")
onready var roundConclusionBG = get_node("RoundConclusion").get_node("Background")
onready var enemyDeckList = get_node("EnemyDeckList")

var enemyLoadDeck = 0 
var cardBattle = preload("res://Main/CardBattle.tscn")
var reveal
var gamerCnt = 0
var pcCnt = 0

func handle_game_conclusion():
	if(deckList.get_child_count() < 5 and enemyDeckList.get_child_count() < 5 ):
		MAIN.gameStatus = 'Draw'
		roundConclusion.visible = true 
		roundConclusionBG.visible = true 
		yield(get_tree().create_timer(3), "timeout")	
		get_tree().change_scene("res://Main/Menu.tscn")
	if(deckList.get_child_count() < 5):
		MAIN.gameStatus = 'Defeat'
		roundConclusion.visible = true 
		roundConclusionBG.visible = true 
		yield(get_tree().create_timer(3), "timeout")	
		get_tree().change_scene("res://Main/Menu.tscn")
	elif(enemyDeckList.get_child_count() < 5):
		MAIN.gameStatus = 'Victory'
		roundConclusion.visible = true 
		roundConclusionBG.visible = true 
		yield(get_tree().create_timer(3), "timeout")	
		get_tree().change_scene("res://Main/Menu.tscn")
		
func handle_end_round():
	MAIN.current_draw = 0 
	MAIN.DRAW_COUNT =  MAIN.DRAW_COUNT + 6
	MAIN.roundCnt = MAIN.roundCnt + 1
	roundLabel.prefix = 'End'
	roundLabel.visible = true 
	MAIN.playerReady = false
	MAIN.enemyBattleReady = false
	roundTransitionTimer.start()
	
func enemy_simulate():
	enemyDrawTimer.start()
	
func clear_battlefield():
	var enemyList = enemyBattleField.get_children()
	var playerList = playerBattleField.get_children()
	
	for enemyChild in enemyList:
		enemyBattleField.remove_child(enemyChild)
		
	for playerChild in playerList:
		playerBattleField.remove_child(playerChild)
		
func clear_hand():		
	var enemyList = enemyHand.get_children()
	var playerList = playerHand.get_children()

	for enemyChild in enemyList:
		enemyHand.remove_child(enemyChild)
		enemyDeckList.add_child(enemyChild)
	
	for playerChild in playerList:
		playerHand.remove_child(playerChild)
		deckList.add_child(playerChild)
		

func ability_lookup(card,field,index):
	match(card):
		'Bed': 
			if(index != 1):
				field[index-1].get_node('CardStats').health = field[index-1].get_node('CardStats').health + 1
			if(index != field.size() -1):
				field[index+1].get_node('CardStats').health = field[index+1].get_node('CardStats').health + 1
		
		'Cookie': 
			if(index != 1):
				field[index-1].get_node('CardStats').attack = field[index-1].get_node('CardStats').attack + 1
			if(index != field.size() -1):
				field[index+1].get_node('CardStats').attack = field[index+1].get_node('CardStats').attack + 1
		
		'Mom':
			for card in field:
				if(card.get_node('CardStats').cardName == 'Gamer'):
					gamerCnt = gamerCnt + 1
				if(card.get_node('CardStats').cardName == 'PC'):
					pcCnt = pcCnt + 1
					card.get_node('CardStats').attack  = 0
					card.get_node('CardStats').health  = 0
			if(pcCnt > 0 and gamerCnt > 0):
					field[index].get_node('CardStats').attack  = field[index].get_node('CardStats').attack + 5
					field[index].get_node('CardStats').health  = field[index].get_node('CardStats').health + 5
					
		'Basement':
			var isPCinField = false
			var isMominField = false
			for card in field:	
				if(card.get_node('CardStats').cardName == 'PC'):
					isPCinField = true 
				if(card.get_node('CardStats').cardName == 'Mom'):
					isMominField = true 
			if(isMominField):
				field[index].get_node('CardStats').health = field[index].get_node('CardStats').health + 3
			for card in field:				
				if(card.get_node('CardStats').cardName == 'Gamer' and isPCinField):
					card.get_node('CardStats').attack = card.get_node('CardStats').attack + 5
					card.get_node('CardStats').health = card.get_node('CardStats').health - 1
					
		'PC':
			for card in field:
				if(card.get_node('CardStats').cardName == 'Gamer'):
					card.get_node('CardStats').health = card.get_node('CardStats').health - 1	
											
		'Gamer Juice':
			for card in field:
				if(card.get_node('CardStats').cardName == 'Gamer'):
					card.get_node('CardStats').attack = card.get_node('CardStats').attack + 1
		
		'Chicken':
			for card in field:
				if(card.get_node('CardStats').cardName == 'Chad'):
					card.get_node('CardStats').attack = card.get_node('CardStats').attack + 3
					
		'Protein':
			for card in field:
				if(card.get_node('CardStats').cardName == 'Chad'):
					card.get_node('CardStats').health = card.get_node('CardStats').health + 3
					
		'Gym':
			var convertChads = false 
			for card in field:
				if(card.get_node('CardStats').cardName == 'Protein' || card.get_node('CardStats').cardName == 'Chicken'):
					convertChads = true
			if(convertChads):
				for card in field:
					if(card.get_node('CardStats').cardName == 'Chad'):
						card.isGigaChad = true 
						card.texture_normal = load('res://Assets/Cards/card-14.png')
						card.texture_pressed =  load('res://Assets/Cards/card-14.png')
						card.get_node('CardStats').attack = card.get_node('CardStats').attack + 2
						card.get_node('CardStats').health = card.get_node('CardStats').health  + 2
						card.get_node('CardStats').effort = 2
				
func handle_ability():
	
	var enemyList = enemyBattleField.get_children()
	var playerList = playerBattleField.get_children()
	var enemyListLength = enemyList.size()
	var playerListLength = playerList.size()
	var maxRoundCheck = max(enemyListLength, playerListLength)
	
	for i in maxRoundCheck:
		
		var curEnemyChild = enemyList[i]
		var curPlayerChild = playerList[i]
		var playerAfterAbilityList 
		var enemyCardType = curEnemyChild.cardType 
		var playerCardType = curPlayerChild.cardType
		
		curEnemyChild.get_node('CardAbility').visible = true 
		curPlayerChild.get_node('CardAbility').visible = true
		
		gamerCnt = 0
		pcCnt = 0
		
		ability_lookup(enemyCardType,enemyList,i)
		
		gamerCnt = 0
		pcCnt = 0
		
		ability_lookup(playerCardType,playerList,i)
		
		yield(get_tree().create_timer(0.25), "timeout")	
		
		curEnemyChild.get_node('CardAbility').visible = false
		curPlayerChild.get_node('CardAbility').visible = false
		
		 
func battle():
	var enemyList = enemyBattleField.get_children()
	var playerList = playerBattleField.get_children()
	var enemyListLength = enemyList.size()
	var playerListLength = playerList.size()
	var maxRoundCheck = max(enemyListLength, playerListLength)
	var playerFinalList = []
	var enemyFinalList = []
	
	handle_ability()
	
	yield(get_tree().create_timer(2), "timeout")	
	
	for i in maxRoundCheck:
		
		var curEnemyChild = enemyList[i]
		var curPlayerChild = playerList[i]
		
		var enemyCardType = curEnemyChild.cardType 
		var playerCardType = curPlayerChild.cardType 
		
		var enemyHealth = curEnemyChild.get_node('CardStats').health
		var playerHealth = curPlayerChild.get_node('CardStats').health
		
		var enemyAttack = curEnemyChild.get_node('CardStats').attack
		var playerAttack = curPlayerChild.get_node('CardStats').attack
		
		var playerPosition = curPlayerChild.get_node('CardPosition').global_position
		var enemyPosition = curEnemyChild.get_node('CardPosition').global_position
		
		var cardBattleAnimation = cardBattle.instance()
		
		cardBattleAnimation.global_position = enemyPosition
		cardBattleAnimation.get_node("Enemy").get_node("CardArt").texture = load(MAIN.cardTypeLookup[enemyCardType].battle)
		cardBattleAnimation.get_node("Player").get_node("CardArt").texture = load(MAIN.cardTypeLookup[playerCardType].battle)
		
		add_child(cardBattleAnimation)
		
		if(enemyHealth > playerAttack):
			curEnemyChild.get_node('CardStats').health = enemyHealth - playerAttack
			enemyFinalList.append(curEnemyChild)

		if(playerHealth > enemyAttack):
			curPlayerChild.get_node('CardStats').health = playerHealth - enemyAttack
			playerFinalList.append(curPlayerChild)
		
	clear_battlefield()
		
	yield(get_tree().create_timer(1.5), "timeout")	
		
	for child in playerFinalList:
		child.remove_hover()
		playerBattleField.add_child(child)
		
	for child in enemyFinalList:
		child.remove_hover()
		enemyBattleField.add_child(child)	
	
	yield(get_tree().create_timer(1), "timeout")	
		
	for child in playerFinalList:
		child.remove_hover()
		playerBattleField.remove_child(child)
		deckList.add_child(child)
		
	for child in enemyFinalList:
		child.remove_hover()
		enemyBattleField.remove_child(child)
		enemyDeckList.add_child(child)

	roundTransitionTimer.start()

func enemy_card_select():
	var childrenList = enemyHand.get_children()
	var battleFieldList = enemyBattleField.get_children()
	randomize()
	if(battleFieldList.size() < 5):
		var child = childrenList[randi()%childrenList.size()]
		child.remove_hover()
		enemyHand.remove_child(child)
		enemyBattleField.add_child(child)
	else:
		MAIN.enemyBattleReady = true 
		if(isReveal()):
			MAIN.combatStatus = 'start' 
		enemySelectTimer.stop()

func enemy_deck_fill():
	for cardOption in MAIN.enemyDeckOptions[MAIN.enemyDifficulty]:
		var loopCnt = cardOption.count;
		var cardValue = cardOption.name;
		for cnt in loopCnt:	
			var deckCard = card.instance()
			deckCard.type = 'Enemy'
			deckCard.cardType = cardValue 
			enemyDeckList.add_child(deckCard)
			MAIN.maxEnemyDeckList = MAIN.maxEnemyDeckList + 1 
			
func enemy_card_draw():
	randomize()
	var enemyDeckListArr = enemyDeckList.get_children()
	var drawCard = enemyDeckListArr[randi()%enemyDeckList.get_child_count()]
	enemyDeckList.remove_child(drawCard)
	enemyHand.add_child(drawCard)

func handle_round_start():
	roundLabel.prefix = 'Start'
	roundLabel.visible = true 
	
func handle_round_display():
	MAIN.roundStatus = 'display'
	roundLabel.prefix = str(MAIN.roundCnt)
	roundLabel.visible = true 
	roundTransitionTimer.start()
	
func handle_round_ongoing():
	roundLabel.visible = false
	
func _ready():
	enemy_deck_fill()
	MAIN.gameStatus = ''
	roundConclusion.visible = false
	roundConclusionBG.visible = false
	MAIN.DRAW_COUNT = 6
	handle_round_display()
		
func isReveal():
	return MAIN.enemyBattleReady and MAIN.playerReady
	
func _process(delta):
	var playerListCnt = playerBattleField.get_child_count()
	if(playerListCnt ==  5 and MAIN.playerReady == false):
		readyButton.disabled = false 
	else: readyButton.disabled = true
	
	if(MAIN.combatStatus == 'start'):
		MAIN.combatStatus = 'ongoing'
		combatMockTimer.start()

func _on_EnemyDrawTimer_timeout():
	if(enemyHand.get_child_count() < MAIN.HAND_COUNT_MAX - 5):
		enemy_card_draw()
	else:
		enemyDrawTimer.stop()
		enemySelectTimer.start()
	
func _on_EnemySelectTimer_timeout():
	enemy_card_select()

func _on_ReadyButton_pressed():
	SOUND.play('Confirm')
	MAIN.playerReady = true
	if(isReveal()):
		MAIN.combatStatus = 'start' 
	 
func _on_CombatMockTimer_timeout():
	battle()

func _on_RoundTransitionTimer_timeout():
	if(MAIN.gameStatus == ''):
		match(MAIN.roundStatus):
			'display':
				MAIN.roundStatus = 'start'
				handle_round_start()
				roundTransitionTimer.start()
			'start':
				MAIN.roundStatus = 'ongoing'
				enemy_simulate()
				handle_round_ongoing()
			'ongoing':
				MAIN.roundStatus = 'end'
				handle_end_round()
			'end':
				clear_hand()
				handle_game_conclusion()
				handle_round_display()

func _on_ExitButton_pressed():
	SOUND.play('Confirm')
	get_tree().change_scene("res://Main/Menu.tscn")
