extends Resource
class_name ItemBase

@export var item_id: String
@export var item_name: String
@export var item_icon: Texture2D
@export var item_stack_size: int = 64
@export var item_sell_price: float
@export_enum("common", "uncommon", "rare", "epic", "legendary", "mythic", "divine", "special", "very special") var rarities: String
@export_enum("block", "sword", "wand", "axe", "hoe", "pickaxe", "helmet", "chestplate", "boots", "accessory", "rod") var item_type: String
