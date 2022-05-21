extends Node

var attack
var health
var cardName
var effort 

onready var cardType = get_parent().cardType

func _ready():
	attack = MAIN.cardTypeLookup[cardType].attack
	health = MAIN.cardTypeLookup[cardType].health
	cardName = MAIN.cardTypeLookup[cardType].name
	effort = MAIN.cardTypeLookup[cardType].effort
