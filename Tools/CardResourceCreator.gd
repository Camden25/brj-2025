@tool
extends Node

func _enter_tree() -> void:
	create_cards()

func create_cards() -> void:
	print("Creating Cards")
	for suit in ["Spade", "Club", "Heart", "Diamond"]:
		for num in ["2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K", "A"]:
			var card = CardResource.new()
			card.number = num
			card.suit = suit
			card.image = load("res://Card System/Assets/" + str(num) + str(suit)[0] + ".png")
			ResourceSaver.save(card, "res://Card System/Cards/" + str(num) + str(suit)[0] + ".tres")
