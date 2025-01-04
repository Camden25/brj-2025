extends Node2D
class_name Card

@warning_ignore("unused_signal")
signal hovered
@warning_ignore("unused_signal")
signal hovered_off

var starting_position: Vector2


func _ready() -> void:
	get_parent().connect_card_signals(self)


func _on_area_2d_mouse_entered() -> void:
	emit_signal("hovered", self)


func _on_area_2d_mouse_exited() -> void:
	emit_signal("hovered_off", self)
