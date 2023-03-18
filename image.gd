extends Panel

@export var image_path : String = ""
@export var image_id: String = ""

var img : Image = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if image_path != "":
		# Display Image
		img = Image.load_from_file(image_path)
		var texture = ImageTexture.create_from_image(img)
		%FileID.text = image_id
		%TextureRect.texture = texture


func _on_process_button_pressed() -> void:
	# Global class
	pass # Replace with function body.


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
