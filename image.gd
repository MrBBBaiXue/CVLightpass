extends Panel

@export var image_path : String = ""
@export var image_id: String = ""

var img : Image = null


func _on_save_button_pressed() -> void:
	var file_dialog = FileDialog.new()
	file_dialog.file_mode = FileDialog.FILE_MODE_SAVE_FILE
	file_dialog.access = FileDialog.ACCESS_FILESYSTEM
	file_dialog.add_filter("*.png, *.jpg, *.jpeg ; Supported Images")
	file_dialog.size = Vector2i(640, 480)
	file_dialog.dialog_hide_on_ok = true
	add_child(file_dialog)
	file_dialog.popup_centered()
	file_dialog.file_selected.connect(_on_image_saved)


func _on_image_saved(path):
	img.save_png(path)


func _on_delete_button_pressed() -> void:
	queue_free()


func _on_process_dark_basc_button_pressed() -> void:
	Global.process_image(image_id, "darkbasc")


func _on_process_retinex_button_pressed() -> void:
	Global.process_image(image_id, "retinex")
