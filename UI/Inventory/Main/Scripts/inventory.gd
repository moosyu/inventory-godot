extends Control

const ITEM_SLOT = preload("res://UI/Inventory/ItemSlot/Scenes/item_slot.tscn")
const WOOD_SWORD = preload("res://Items/Swords/WoodenSword/wood_sword.tres")
const DIRT = preload("res://Items/Materials/Dirt/dirt.tres")

@onready var slot_container: GridContainer = $SlotContainer

const ROW_SIZE: int = 4
const COL_SIZE: int = 9

func _ready() -> void:
	# initalise array of size 4 (for the 4 rows)
	Global.inventory_items.resize(COL_SIZE)
	for x in range(ROW_SIZE):
		# append an empty [] for every row
		Global.inventory_items[x] = []
		for y in range(COL_SIZE):
			var slot_instance = ITEM_SLOT.instantiate()
			slot_container.add_child(slot_instance)
			slot_instance.slot_num = Vector2i(x, y)
			Global.inventory_items[x].append(slot_instance)
			slot_instance.slot_pressed.connect(remove_item)

	add_item(WOOD_SWORD)
	add_item(WOOD_SWORD)
	add_item(DIRT)
	for z in range(100):
		add_item(DIRT)

func add_item(new_item: ItemBase) -> void:
	for x in range(ROW_SIZE):
		for y in range(COL_SIZE):
			if Global.inventory_items[x][y].add_item(new_item):
				return
	Global.stash.append(new_item)

func remove_item(slot_num: Vector2i, button_index: int, item_in_slot: bool) -> void:
	var clicked_slot: Panel = Global.inventory_items[slot_num.x][slot_num.y]

	match button_index:
		MOUSE_BUTTON_LEFT:
			if Global.hand_item.is_empty() and item_in_slot:
				Global.hand_item = {"item": clicked_slot.item, "quantity": clicked_slot.item_count}
				clicked_slot.reset_slot()
			elif not Global.hand_item.is_empty():
				var hand_item = Global.hand_item["item"]
				var hand_quantity = Global.hand_item["quantity"]
				if not item_in_slot:
					clicked_slot.add_item_n(hand_item, hand_quantity)
					Global.hand_item = {}
				elif clicked_slot.item == hand_item:
					var space_left = hand_item.item_stack_size - clicked_slot.item_count
					var to_place = min(space_left, hand_quantity)
					if to_place > 0:
						clicked_slot.add_item_n(hand_item, to_place)
						Global.hand_item["quantity"] -= to_place
						if Global.hand_item["quantity"] <= 0:
							Global.hand_item = {}
				elif clicked_slot.item != hand_item:
					var temp_item = clicked_slot.item
					var temp_quantity = clicked_slot.item_count
					clicked_slot.reset_slot()
					clicked_slot.add_item_n(hand_item, hand_quantity)
					Global.hand_item = {"item": temp_item, "quantity": temp_quantity}
		MOUSE_BUTTON_RIGHT:
			if not Global.hand_item.is_empty():
				var hand_item = Global.hand_item["item"]
				var hand_quantity = Global.hand_item["quantity"]
				if hand_quantity >= 1:
					if not item_in_slot:
						clicked_slot.add_item_n(hand_item, 1)
						Global.hand_item["quantity"] -= 1
					elif clicked_slot.item == hand_item and clicked_slot.item_count < hand_item.item_stack_size:
						clicked_slot.add_item_n(hand_item, 1)
						Global.hand_item["quantity"] -= 1
					if Global.hand_item["quantity"] <= 0:
						Global.hand_item = {}
			elif Global.hand_item.is_empty() and item_in_slot:
				if clicked_slot.item_count > 1:
					var half = floor(clicked_slot.item_count / 2)
					Global.hand_item = {"item": clicked_slot.item, "quantity": half}
					clicked_slot.item_count -= half
					if clicked_slot.item.item_stack_size > 1:
						clicked_slot.item_count_label.text = str(clicked_slot.item_count)
						clicked_slot.item_count_label.visible = clicked_slot.item_count > 1
				if clicked_slot.item_count <= 0:
					clicked_slot.reset_slot()
