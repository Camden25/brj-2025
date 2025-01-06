extends Node2D
class_name Deck

const CARD_SCENE_PATH: String = "res://Card System/Scenes/Card.tscn"
const CARD_DRAW_SPEED: float = 0.25

var player_deck: Array = ["kight", "kight", "kight", "kight", "kight", "kight", "kight"]

@onready var player_hand: PlayerHand = get_tree().get_first_node_in_group("PlayerHand")
@onready var card_manager: CardManager = get_tree().get_first_node_in_group("CardManager")


func draw_card() -> void:
	var card_drawn = player_deck[0]
	player_deck.erase(card_drawn)
	
	if player_deck.size() == 0:
		$Area2D/CollisionShape2D.disabled = true
		$Sprite2D.visible = false
	
	var card_scene = preload(CARD_SCENE_PATH)
	var new_card: Card = card_scene.instantiate()
	new_card.name = "Card"
	card_manager.add_child(new_card)
	player_hand.add_card_to_hand(new_card, CARD_DRAW_SPEED)
