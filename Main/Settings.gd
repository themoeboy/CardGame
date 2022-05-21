extends Control

onready var easyButton = get_node("EasyButton")
onready var hardButton = get_node("HardButton")
onready var mediumButton = get_node("MediumButton")

func _on_MusicSlider_value_changed(value):
	AudioServer.set_bus_volume_db(1,lerp(AudioServer.get_bus_volume_db(1),value,0.5))


func _on_MainSlider_value_changed(value):
	AudioServer.set_bus_volume_db(0,lerp(AudioServer.get_bus_volume_db(0),value,0.5))

func _on_ExitButton_pressed():
	SOUND.play('Confirm')
	get_tree().change_scene("res://Main/Menu.tscn")
	
	
func _process(delta):
	match(MAIN.enemyDifficulty):
		'Easy':
			easyButton.texture_normal = load('res://Assets/easybutton-colored.png')
			mediumButton.texture_normal= load('res://Assets/mediumbutton-gray.png')
			hardButton.texture_normal= load('res://Assets/hardbutton-gray.png')
		'Medium':
			easyButton.texture_normal = load('res://Assets/easybutton-gray.png')
			mediumButton.texture_normal = load('res://Assets/mediumbutton-colored.png')
			hardButton.texture_normal= load('res://Assets/hardbutton-gray.png')
		'Hard':
			easyButton.texture_normal = load('res://Assets/easybutton-gray.png')
			mediumButton.texture_normal= load('res://Assets/mediumbutton-gray.png')
			hardButton.texture_normal = load('res://Assets/hardbutton-colored.png')
	
func _on_EasyButton_pressed():
	SOUND.play('Confirm')
	MAIN.enemyDifficulty = 'Easy'

func _on_MediumButton_pressed():
	SOUND.play('Confirm')
	MAIN.enemyDifficulty = 'Medium'

func _on_HardButton_pressed():
	SOUND.play('Confirm')
	MAIN.enemyDifficulty = 'Hard'
