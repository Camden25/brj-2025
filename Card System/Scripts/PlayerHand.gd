extends Node2D
class_name PlayerHand

const CARD_HAND_WIDTH: int = 500
const CARD_HAND_HEIGHT: int = 50
const HAND_Y_POSITION: int = 880
const DEFAULT_CARD_MOVE_SPEED: float = 0.15

var player_hand: Array[Card] = []
var center_screen_x: float

@onready var card_manager = get_tree().get_first_node_in_group("CardManager")


func _ready() -> void:
	center_screen_x = get_viewport().size.x/2


func add_card_to_hand(card: Card, speed: float) -> void:
	if card not in player_hand:
		player_hand.insert(0, card)
		update_hand_positions(speed)
	else:
		animate_card_to_position(card, card.starting_position, DEFAULT_CARD_MOVE_SPEED)


func remove_card_from_hand(card: Card) -> void:
	if card in player_hand:
		player_hand.erase(card)
		update_hand_positions(DEFAULT_CARD_MOVE_SPEED)


func update_hand_positions(speed: float) -> void:
	for i in range(player_hand.size()):
		var new_position = calculate_card_position(i)
		var card = player_hand[i]
		card.starting_position = new_position
		animate_card_to_position(card, new_position, speed)


func calculate_card_position(index) -> Vector2:
	var total_width: float = (player_hand.size() - 1)
	var hand_width: float = 100 * total_width
	var relative_index: float = 0.5
	if player_hand.size() > 1:
		relative_index = index/total_width
	var x_offset: float = center_screen_x + relative_index * hand_width - float(hand_width)/2
	var y_offset: float = HAND_Y_POSITION - calculate_height(relative_index)*CARD_HAND_HEIGHT
	return Vector2(x_offset, y_offset)


func animate_card_to_position(card: Card, new_position: Vector2, speed: float) -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(card, "position", new_position, speed)


func calculate_height(value) -> float:
	var curve = preload("res://Card System/Assets/HandHeightCurve.tres").curve
	return curve.sample_baked(value)
