extends Panel

@onready var item_texture: TextureRect = $ItemTexture
@onready var item_count_label: Label = $ItemCountLabel

func _process(delta: float) -> void:
	if Global.hand_item.is_empty():
		visible = false
	else:
		visible = true
		item_texture.texture = Global.hand_item["item"].item_icon
		if Global.hand_item["quantity"] > 1:
			item_count_label.text = str(Global.hand_item["quantity"])
		else:
			item_count_label.text = ""
		position = Vector2i(get_global_mouse_position().x - 32, get_global_mouse_position().y - 32)
