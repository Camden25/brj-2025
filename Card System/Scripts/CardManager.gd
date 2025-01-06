extends Node2D
class_name CardManager

const COLLISION_MASK_CARD: int = 1
const COLLISION_MASK_CARD_SLOT: int = 2
const DEFAULT_CARD_MOVE_SPEED: float = 0.15

var card_being_dragged: Card
var is_hovering_on_card: bool

@onready var player_hand_reference: PlayerHand = get_tree().get_first_node_in_group("PlayerHand")
@onready var input_manager: InputManager = get_tree().get_first_node_in_group("InputManager")


func _ready() -> void:
	input_manager.connect("left_mouse_button_released", on_left_click_released)


func _process(_delta) -> void:
	if card_being_dragged:
		var mouse_pos = get_global_mouse_position()
		card_being_dragged.position = Vector2(clamp(mouse_pos.x,0,get_viewport_rect().size.x),clamp(mouse_pos.y,0,get_viewport_rect().size.y))


func start_drag(card: Card) -> void:
	card_being_dragged = card
	card.scale = Vector2(1,1)
	card_being_dragged.z_index = 2


func finish_drag() -> void:
	card_being_dragged.scale = Vector2(1,1)
	var card_slot_found: CardSlot = raycast_check_for_card_slot()
	card_being_dragged.z_index = 1
	if card_slot_found and !card_slot_found.card_in_slot:
		player_hand_reference.remove_card_from_hand(card_being_dragged)
		card_being_dragged.position = card_slot_found.position
		card_being_dragged.get_node("Area2D/CollisionShape2D").disabled = true
		card_slot_found.card_in_slot = true
	else:
		player_hand_reference.add_card_to_hand(card_being_dragged, DEFAULT_CARD_MOVE_SPEED)
	card_being_dragged = null


func connect_card_signals(card: Card) -> void:
	card.connect("hovered", on_hovered_over_card)
	card.connect("hovered_off", on_hovered_off_card)


func on_left_click_released() -> void:
	if card_being_dragged:
				finish_drag()


func on_hovered_over_card(card: Card) -> void:
	if !is_hovering_on_card:
		is_hovering_on_card = true
		highlight_card(card, true)


func on_hovered_off_card(card: Card) -> void:
	if !card_being_dragged:
		highlight_card(card, false)
		
		var new_card_hovered = raycast_check_for_card()
		if new_card_hovered:
			highlight_card(new_card_hovered, true)
		else:
			is_hovering_on_card = false


func highlight_card(card: Card, hovered: bool):
	if hovered:
		card.scale = Vector2(1,1)
		card.get_node("Sprite2D").offset.y = -50
		card.z_index = 1
	else:
		card.scale = Vector2(1,1)
		card.get_node("Sprite2D").offset.y = 0
		card.z_index = 1


func raycast_check_for_card_slot() -> CardSlot:
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = COLLISION_MASK_CARD_SLOT
	var result = space_state.intersect_point(parameters)
	if result.size() > 0:
		return result[0].collider.get_parent()
	return null


func raycast_check_for_card() -> Card:
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = COLLISION_MASK_CARD
	var result = space_state.intersect_point(parameters)
	if result.size() > 0:
		return get_card_with_highest_z_index(result)
	return null


func get_card_with_highest_z_index(cards) -> Card:
	var highest_z_card = cards[0].collider.get_parent()
	var highest_z_index = highest_z_card.z_index
	
	for i in range(1, cards.size()):
		var current_card = cards[i].collider.get_parent()
		if current_card.z_index > highest_z_index:
			highest_z_card = current_card
			highest_z_index = current_card.z_index
	
	return highest_z_card
