extends Node


var enemyBattleReady = false 
var playerReady = false 
var combatStatus

var maxDeckList = 0
const HAND_COUNT_MAX = 10
var DRAW_COUNT = 0
var roundStatus
var roundCnt = 1
var current_draw = 0
const MAX_BATTLEFIELD = 5

var enemyCard = {
	'normal': 'res://Assets/cardbackmockup.png',
	'pressed': 'res://Assets/cardbackmockup.png',
}

export onready var cardTypeLookup = {
	'Dude': {
		'normal': 'res://Assets/Cards/card-1.png',
		'pressed': 'res://Assets/Cards/card-1.png',
		'battle': 'res://Assets/Cards/cardBattleTemplate.png',
		'name': 'Dude',
		'effort': 4,
		'attack': 7,
		'health': 5,
		'ability': 'Just a dude',
	},
	'Bed': {
		'normal': 'res://Assets/Cards/card-2.png',
		'pressed': 'res://Assets/Cards/card-2.png',
		'battle': 'res://Assets/Cards/cardBattleTemplate.png',
		'name': 'Bed',
		'effort': 4,
		'attack': 0,
		'health': 5,
		'ability': 'Give +1 Health to surrounding allies',
	},
	'Cookie': {
		'normal': 'res://Assets/Cards/card-3.png',
		'pressed': 'res://Assets/Cards/card-3.png',
		'battle': 'res://Assets/Cards/cardBattleTemplate.png',
		'name': 'Cookie',
		'effort': 3,
		'attack': 1,
		'health': 1,
		'ability': 'Give +1 Attack to surrounding allies',
	},
	'Gamer Juice': {
		'normal': 'res://Assets/Cards/card-4.png',
		'pressed': 'res://Assets/Cards/card-4.png',
		'battle': 'res://Assets/Cards/cardBattleTemplate.png',
		'name': 'Juice',
		'effort': 1,
		'attack': 1,
		'health': 3,
		'ability': 'Give +1 Attack to Gamers',
	},
	'PC': {
		'normal': 'res://Assets/Cards/card-5.png',
		'pressed': 'res://Assets/Cards/card-5.png',
		'battle': 'res://Assets/Cards/cardBattleTemplate.png',
		'name': 'PC',
		'effort': 2,
		'attack': 1,
		'health': 3,
		'ability': 'Give -1 health to Gamers',
	},
	'Gamer': {
		'normal': 'res://Assets/Cards/card-6.png',
		'pressed': 'res://Assets/Cards/card-6.png',
		'battle': 'res://Assets/Cards/cardBattleTemplate.png',
		'name': 'Gamer',
		'effort': 3,
		'attack': 3,
		'health': 3,
		'ability': 'Likes to Game',
	},
	'Basement': {
		'normal': 'res://Assets/Cards/card-7.png',
		'pressed': 'res://Assets/Cards/card-7.png',
		'battle': 'res://Assets/Cards/cardBattleTemplate.png',
		'name': 'Basement',
		'effort': 10,
		'attack': 0,
		'health': 20,
		'ability': 'If PC is in field , Give +5 Attack and -1 Health to Gamers. If Mom is on field, Basement recovers 3 health',
	},
	'Mom': {
		'normal': 'res://Assets/Cards/card-8.png',
		'pressed': 'res://Assets/Cards/card-8.png',
		'battle': 'res://Assets/Cards/cardBattleTemplate.png',
		'name': 'Mom',
		'effort': 6,
		'attack': 10,
		'health': 10,
		'ability': 'If Gamer and PC is in field, gains 5 attack and  5 Health. But PC will have no stats',
	},
	'Gym': {
		'normal': 'res://Assets/Cards/card-9.png',
		'pressed': 'res://Assets/Cards/card-9.png',
		'battle': 'res://Assets/Cards/cardBattleTemplate.png',
		'name': 'Gym',
		'effort': 8,
		'attack': 6,
		'health': 6,
		'ability': 'Transform Chads into Giga Chads if any of the following is present in the field ( Protein , Chicken )',
	},
	'Protein': {
		'normal': 'res://Assets/Cards/card-10.png',
		'pressed': 'res://Assets/Cards/card-10.png',
		'battle': 'res://Assets/Cards/cardBattleTemplate.png',
		'name': 'Protein',
		'effort': 1,
		'attack': 1,
		'health': 5,
		'ability': 'Give +3 Health to Chads',
	},
	'Chicken': {
		'normal': 'res://Assets/Cards/card-11.png',
		'pressed': 'res://Assets/Cards/card-11.png',
		'battle': 'res://Assets/Cards/cardBattleTemplate.png',
		'name': 'Chicken',
		'effort': 2,
		'attack': 2,
		'health': 3,
		'ability': ' A slab of Chicken Breast. Give +3 Attack to Chads',
	},
	'Chad': {
		'normal': 'res://Assets/Cards/card-12.png',
		'pressed': 'res://Assets/Cards/card-12.png',
		'battle': 'res://Assets/Cards/cardBattleTemplate.png',
		'alternate': 'res://Assets/Cards/card-14.png',
		'name': 'Chad',
		'effort': 6,
		'attack': 4,
		'health': 4,
		'ability': 'Chad.',
	},
	
}

onready var cardTypes = cardTypeLookup.keys()

var enemyDeckOptions = {
	'Easy': [
		{
			'name':'Dude',
			'count': 10,
		},
		{
			'name':'Bed',
			'count': 5,
		},
		{
			'name':'Cookie',
			'count': 5,
		},
		{
			'name':'Gamer Juice',
			'count': 5,
		},
	],
	'Medium': [
		{
			'name':'Gamer',
			'count': 4,
		},
		{
			'name':'Mom',
			'count': 5,
		},
		{
			'name':'PC',
			'count': 4,
		},
		{
			'name':'Basement',
			'count': 3,
		},
	],
	'Hard': [
		{
			'name':'Chad',
			'count': 6,
		},
		{
			'name':'Gym',
			'count': 4,
		},
		{
			'name':'Protein',
			'count': 6,
		},
		{
			'name':'Chicken',
			'count': 3,
		},
	],
}

var gameStatus = ''
var abilityDisplay = ''
var deckList = []
var enemyDeckList = []
var maxEnemyDeckList = 0
var enemyDifficulty = 'Easy'

func game_wipe():
	playerReady = false
	enemyDeckList = []
	maxEnemyDeckList = 0
	roundCnt = 1
	DRAW_COUNT = 0
