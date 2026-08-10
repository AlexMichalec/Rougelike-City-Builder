class_name CardInfo

var title:String = "New Card"
var cost:Array[int] = [0,0,0]
var category:String 
var art_card = "res://icon.svg"
var art_hex:String
var art_hex_big:String
var red_action_text:String
var blue_action_text:String 
var green_action_text:String
var any_action_text:String
var on_build_action_text:String

func to_dict():
	var result = {
	"title": title,
	"cost": cost,
	"category": category,
	"art_card": art_card,
	"art_hex": art_hex,
	"art_hex_big": art_hex_big,
	"red_action_text": red_action_text,
	"blue_action_text": blue_action_text,
	"green_action_text": green_action_text,
	"any_action_text": any_action_text,
	"on_build_action_text": on_build_action_text
	}
	return result

static func from_dict(data: Dictionary) -> CardInfo:
	var card = CardInfo.new()
	card.title = data["title"]
	card.cost[0] = data["cost"][0]
	card.cost[1] = data["cost"][1]
	card.cost[2] = data["cost"][2]
	card.category = data["category"]
	card.art_card = data["art_card"]
	card.art_hex = data["art_hex"]
	card.art_hex_big = data["art_hex_big"]
	card.red_action_text = data["red_action_text"]
	card.blue_action_text = data["blue_action_text"]
	card.green_action_text = data["green_action_text"]
	card.any_action_text = data["any_action_text"]
	card.on_build_action_text = data["on_build_action_text"]

	return card
	
	
