extends Control

# Parameter Container.
# Would be easier if changed to child scene.
@onready var p1value = %MethodDarkContainer/ParamContainer1/LabelContainer/ValueParam
@onready var p2value = %MethodDarkContainer/ParamContainer2/LabelContainer/ValueParam
@onready var p3value = %MethodDarkContainer/ParamContainer3/LabelContainer/ValueParam

@onready var p4value = %MethodRetinexContainer/ParamContainer1/LabelContainer/ValueParam
@onready var p5value = %MethodRetinexContainer/ParamContainer2/LabelContainer/ValueParam
@onready var p6value = %MethodRetinexContainer/ParamContainer3/LabelContainer/ValueParam
# Slider nodes
@onready var p1slider = %MethodDarkContainer/ParamContainer1/SliderParam
@onready var p2slider = %MethodDarkContainer/ParamContainer2/SliderParam
@onready var p3slider = %MethodDarkContainer/ParamContainer3/SliderParam

@onready var p4slider = %MethodRetinexContainer/ParamContainer1/SliderParam
@onready var p5slider = %MethodRetinexContainer/ParamContainer2/SliderParam
@onready var p6slider = %MethodRetinexContainer/ParamContainer3/SliderParam


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
	p1value.text = str(p1slider.value)
	p2value.text = str(p2slider.value)
	p3value.text = str(p3slider.value)
	p4value.text = str(p4slider.value)
	p5value.text = str(p5slider.value)
	p6value.text = str(p6slider.value)
	Global.w = float(p1value.text)
	Global.r = float(p2value.text)
	Global.maxV1 = float(p3value.text)
	Global.sigma = [int(p4value.text), int(p5value.text), int(p6value.text)]
