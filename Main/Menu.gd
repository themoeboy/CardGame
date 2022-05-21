extends Control


func _ready():
	if(MAIN.maxDeckList < 5): get_node('StartButton').disabled = true
	pass

func _on_ExitButton_pressed():
	SOUND.play('Confirm')
	get_tree().quit()

func _on_StartButton_pressed():
	SOUND.play('Confirm')
	MAIN.game_wipe()
	get_tree().change_scene("res://Main/Board.tscn")

func _on_DeckButton_pressed():
	SOUND.play('Confirm')
	get_tree().change_scene("res://Main/DeckBuildMenu.tscn")

func _on_SettingsButton_pressed():
	SOUND.play('Confirm')
	get_tree().change_scene("res://Main/Settings.tscn")
