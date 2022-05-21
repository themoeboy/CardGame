extends Node

onready var confirm = preload("res://SFX/Confirm.tscn")
onready var draw = preload("res://SFX/Draw.tscn")
onready var place = preload("res://SFX/Place.tscn")
onready var music = preload("res://SFX/Music.tscn")

func play(sound):
	if(sound != null): get_node(sound).play()

func stop(sound):
	get_node(sound).play()

func _ready():
	confirm = confirm.instance()
	draw = draw.instance()
	place = place.instance()
	music = music.instance()
	add_child(confirm)
	add_child(draw)
	add_child(place)
	add_child(music)
	play('Music')	
	



	

	
