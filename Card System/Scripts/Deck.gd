extends Node2D
class_name Deck

const CARD_SCENE_PATH: String = "res://Card System/Scenes/Card.tscn"
const CARD_DRAW_SPEED: float = 0.25

@export var fixed_hand_size: bool = false
@export var max_hand_size: int = 5

var can_draw_cards = false

@export var player_deck: Array[CardResource] = []
var player_discard: Array[CardResource] = []

@onready var player_hand: PlayerHand = get_tree().get_first_node_in_group("PlayerHand")
@onready var card_manager: CardManager = get_tree().get_first_node_in_group("CardManager")


func _process(_delta: float) -> void:
	if fixed_hand_size == true or player_hand.player_hand.size() >= max_hand_size:
		can_draw_cards = false
	else:
		can_draw_cards = true
	
	if fixed_hand_size == true and player_hand.player_hand.size() < max_hand_size and player_deck.size() > 0:
		draw_card()


func draw_card() -> void:
	var card_drawn = player_deck[0]
	player_deck.erase(card_drawn)
	#player_discard.append(card_drawn)
	
	if player_deck.size() == 0:
		$Area2D/CollisionShape2D.disabled = true
		$Sprite2D.visible = false
	
	var card_scene = preload(CARD_SCENE_PATH)
	var new_card: Card = card_scene.instantiate()
	new_card.name = str(card_drawn.number) + str(card_drawn.suit)
	new_card.suit = card_drawn.suit
	new_card.number = card_drawn.number
	new_card.image = card_drawn.image
	card_manager.add_child(new_card)
	player_hand.add_card_to_hand(new_card, CARD_DRAW_SPEED)
