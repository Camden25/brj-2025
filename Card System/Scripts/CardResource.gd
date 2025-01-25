extends Resource
class_name CardResource

@export_enum("Spade", "Club", "Heart", "Diamond", "Wild") var suit: String
@export_enum("0", "2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K", "A", "W") var number: String
@export var image: Texture
