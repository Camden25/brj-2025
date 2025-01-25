extends Node
class_name HandEvaluator


const VALUES = ["2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K", "A"]
const SUITS = ["Spade", "Club", "Heart", "Diamond", "Wild"]

@export var hand_1: Array[CardResource]
@export var hand_2: Array[CardResource]


func rank_hand(hand: Array) -> Dictionary:
	var value_counts = {}
	var suit_counts = {}
	var wild_cards = 0
	
	for card in hand:
		if card.suit == "Wild":
			wild_cards += 1
			continue
		value_counts[card.number] = value_counts.get(card.number, 0) + 1
		suit_counts[card.suit] = suit_counts.get(card.suit, 0) + 1
	
	var sorted_values = []
	for value in VALUES:
		if value_counts.has(value):
			sorted_values.append(value)
	
	return evaluate_hand(sorted_values, suit_counts, wild_cards)

func evaluate_hand(values: Array, suits: Dictionary, wild_cards: int) -> Dictionary:
	var straight = is_straight(values, wild_cards)
	var flush = is_flush(suits)
	var value_counts_sorted = values_count_sorted(values, wild_cards)
	var output = {"rank": 0, "high_card": ""}
	
	if value_counts_sorted[0] == 5:
		output["rank"] = 10  # Five of a kind
		output["high_card"] = get_high_card(values, value_counts_sorted, 5)
	elif straight and flush:
		output["rank"] = 9 # Straight Flush
		output["high_card"] = highest_in_straight(values)
	elif value_counts_sorted[0] == 4:
		output["rank"] = 8  # Four of a kind
		output["high_card"] = get_high_card(values, value_counts_sorted, 4)
	elif value_counts_sorted[0] == 3 and value_counts_sorted[1] >= 2:
		output["rank"] = 7  # Full house
		output["high_card"] = get_high_card(values, value_counts_sorted, 3)
	elif flush:
		output["rank"] = 6  # Flush
		output["high_card"] = highest_in_flush(values)
	elif straight:
		output["rank"] = 5  # Straight
		output["high_card"] = highest_in_straight(values)
	elif value_counts_sorted[0] == 3:
		output["rank"] = 4  # Three of a kind
		output["high_card"] = get_high_card(values, value_counts_sorted, 3)
	elif value_counts_sorted[0] == 2 and value_counts_sorted[1] == 2:
		output["rank"] = 3  # Two pair
		output["high_card"] = get_high_card(values, value_counts_sorted, 2)
	elif value_counts_sorted[0] == 2:
		output["rank"] = 2  # One pair
		output["high_card"] = get_high_card(values, value_counts_sorted, 2)
	else:
		output["rank"] = 1  # High card
		output["high_card"] = highest_card(values)
	
	return output


func is_straight(values: Array, wild_cards: int) -> bool:
	var indices = []
	for value in values:
		indices.append(VALUES.find(value))
	indices.sort()
	
	for i in range(indices.size() - 1):
		if indices[i + 1] - indices[i] > 1:
			wild_cards -= (indices[i + 1] - indices[i] - 1)
			if wild_cards < 0:
				return false
	
	return true


func highest_in_straight(values: Array) -> String:
	return highest_card(values)


func is_flush(suits: Dictionary) -> bool:
	for suit in suits.keys():
		if suits[suit] >= 5:
			return true
	return false


func highest_in_flush(values: Array) -> String:
	return highest_card(values)


func values_count_sorted(values: Array, wild_cards: int) -> Array:
	var value_counts = {}
	for value in values:
		value_counts[value] = value_counts.get(value, 0) + 1
	
	var counts = value_counts.values()
	counts.sort()
	counts.reverse()
	
	while wild_cards > 0 and counts.size() > 0:
		counts[0] += 1
		wild_cards -= 1
		counts.sort()
		counts.reverse()
	
	print(counts)
	return counts


func highest_card(values: Array) -> String:
	var indices = []
	for value in values:
		indices.append(VALUES.find(value))
	indices.sort()
	indices.reverse()
	return VALUES[indices[0]]


func get_high_card(values: Array, value_counts_sorted: Array, count: int) -> String:
	for value in values:
		if value_counts_sorted.has(count):
			return value
	return ""


func compare_hands(hand1: Array, hand2: Array) -> String:
	var rank1 = rank_hand(hand1)
	var rank2 = rank_hand(hand2)
	
	if rank1["rank"] > rank2["rank"]:
		return "Hand 1 wins!"
	elif rank2["rank"] > rank1["rank"]:
		return "Hand 2 wins!"
	else:
		if VALUES.find(rank1["high_card"]) > VALUES.find(rank2["high_card"]):
			return "Hand 1 wins!"
		elif VALUES.find(rank2["high_card"]) > VALUES.find(rank1["high_card"]):
			return "Hand 2 wins!"
		else:
			return "It's a tie!"


func _ready():
	var result = compare_hands(hand_1, hand_2)
	print(result)
