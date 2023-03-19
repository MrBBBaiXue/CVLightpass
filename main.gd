extends Control

# Parameter Container.
# Would be easier if changed to child scene.
@onready var param1_value = %MethodDarkContainer/ParamContainer1/LabelContainer/ValueParam
@onready var param2_value = %MethodDarkContainer/ParamContainer2/LabelContainer/ValueParam
@onready var param3_value = %MethodRetinexContainer/ParamContainer1/LabelContainer/ValueParam
@onready var param4_value = %MethodRetinexContainer/ParamContainer2/LabelContainer/ValueParam
@onready var param5_value = %MethodRetinexContainer/ParamContainer3/LabelContainer/ValueParam
# Slider nodes
@onready var param1_slider = %MethodDarkContainer/ParamContainer1/SliderParam
@onready var param2_slider = %MethodDarkContainer/ParamContainer2/SliderParam
@onready var param3_slider = %MethodRetinexContainer/ParamContainer1/SliderParam
@onready var param4_slider = %MethodRetinexContainer/ParamContainer2/SliderParam
@onready var param5_slider = %MethodRetinexContainer/ParamContainer3/SliderParam


# Called when the node enters the scene tree for the first time.
func _ready():
	_update_params()
	# Register Image list node
	Global.imagelist = %ImageList
	# Check backend status
	var test_request = HTTPRequest.new()
	add_child(test_request)
	test_request.request_completed.connect(func(result, response_code, headers, body):
		var response = body.get_string_from_utf8()
		print(response)
		if response == "pong":
			%ServerStatus.text = "已连接后端服务器"
		else:
			%ServerStatus.text = "连接失败"
		test_request.queue_free()
		)
	var error = test_request.request(Global.api + "/api/ping")
	print(error)
	if error != OK:
		push_error(error)


#------------------------------
# Operation button
#------------------------------
func _on_import_button_pressed():
	var file_dialog = FileDialog.new()
	file_dialog.file_mode = FileDialog.FILE_MODE_OPEN_FILE
	file_dialog.access = FileDialog.ACCESS_FILESYSTEM
	file_dialog.add_filter("*.png, *.jpg, *.jpeg ; Supported Images")
	file_dialog.size = Vector2i(640, 480)
	file_dialog.dialog_hide_on_ok = true
	add_child(file_dialog)
	file_dialog.popup_centered()
	file_dialog.file_selected.connect(_on_image_imported)


func _on_image_imported(path):
	Global.add_image(path)


#------------------------------
# slider value -> label text
#------------------------------
func _on_param_value_changed(value):
	_update_params()


func _update_params():
	param1_value.text = str(param1_slider.value)
	param2_value.text = str(param2_slider.value)
	param3_value.text = str(param3_slider.value)
	param4_value.text = str(param4_slider.value)
	param5_value.text = str(param5_slider.value)
	Global.w = float(param1_value.text)
	Global.t = float(param2_value.text)
	Global.sigma = [int(param3_value.text), int(param4_value.text), int(param5_value.text)]
