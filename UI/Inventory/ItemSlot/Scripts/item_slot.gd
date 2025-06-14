extends Panel

@onready var item_count_label: Label = $ItemCountLabel
@onready var slot_item_texture: TextureRect = $SlotItemTexture

var slot_num: Vector2i
var item: ItemBase
var item_count: int = 0
var item_in_slot: bool = false

signal slot_pressed(button_index: int)

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT or event.button_index == MOUSE_BUTTON_RIGHT:
			emit_signal("slot_pressed", slot_num, event.button_index, item_in_slot)

func add_item(new_item: ItemBase) -> bool:
	if item_count == 0 or new_item == item and item_count < new_item.item_stack_size:
		item_in_slot = true
		slot_item_texture.texture = new_item.item_icon
		item_count += 1
		item = new_item
		if item.item_stack_size > 1:
			item_count_label.visible = true
			item_count_label.text = str(item_count)
		return true
	else:
		return false
		
func add_item_n(new_item: ItemBase, count: int) -> void:
	item_in_slot = true
	slot_item_texture.texture = new_item.item_icon
	item = new_item
	item_count += count
	if item.item_stack_size > 1:
		item_count_label.visible = item_count > 1
		item_count_label.text = str(item_count)
	else:
		item_count_label.visible = false

func reset_slot() -> void:
	item = null
	item_in_slot = false
	slot_item_texture.texture = null
	item_count = 0
	item_count_label.visible = false
