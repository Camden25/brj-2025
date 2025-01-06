extends Node2D
class_name InputManager

signal left_mouse_button_clicked
signal left_mouse_button_released

const COLLISION_MASK_CARD = 1
const COLLISION_MASK_CARD_SLOT = 2
const COLLISION_MASK_DECK = 4

@onready var card_manager: CardManager = get_tree().get_first_node_in_group("CardManager")
@onready var deck_reference: Deck = get_tree().get_first_node_in_group("Deck")


func _input(event) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			emit_signal("left_mouse_button_clicked")
			raycast_at_cursor()
		else:
			emit_signal("left_mouse_button_released")


func raycast_at_cursor() -> void:
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	var result = space_state.intersect_point(parameters)
	if result.size() > 0:
		var result_collision_mask = result[0].collider.collision_mask
		if result_collision_mask == COLLISION_MASK_CARD:
			# card clicked
			var card_found = result[0].collider.get_parent()
			if card_found:
				card_manager.start_drag(card_found)
		if result_collision_mask == COLLISION_MASK_DECK:
			# deck clicked
			deck_reference.draw_card()
