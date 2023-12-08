extends Node

var score := 0
var combo := 0
var player

func increase_score():
	score += int(1000 * (1.0 + float(combo) / 100.0))
	combo += 1
	player.set_labels()

func miss():
	combo = 0
	player.set_labels()
