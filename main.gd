extends Control

# Parameter Container.
# Would be easier if changed to child scene.
@onready var param1_value = %MethodDarkContainer/ParamContainer1/LabelContainer/ValueParam
@onready var param2_value = %MethodDarkContainer/ParamContainer2/LabelContainer/ValueParam
@onready var param3_value = %MethodRetinexContainer/ParamContainer1/LabelContainer/ValueParam
@onready var param4_value = %MethodRetinexContainer/ParamContainer2/LabelContainer/ValueParam
@onready var param1_slider = %MethodDarkContainer/ParamContainer1/SliderParam
@onready var param2_slider = %MethodDarkContainer/ParamContainer2/SliderParam
@onready var param3_slider = %MethodRetinexContainer/ParamContainer1/SliderParam
@onready var param4_slider = %MethodRetinexContainer/ParamContainer2/SliderParam


# Called when the node enters the scene tree for the first time.
func _ready():
	param1_value.text = str(param1_slider.value)
	param2_value.text = str(param2_slider.value)
	param3_value.text = str(param3_slider.value)
	param4_value.text = str(param4_slider.value)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


#------------------------------

#------------------------------
func _on_import_button_pressed():
	var file_dialog = FileDialog.new()
	file_dialog.file_mode = FileDialog.FILE_MODE_OPEN_FILE
	add_child(file_dialog)
	file_dialog.popup_centered()
	pass # Replace with function body.

func _on_process_button_pressed():
	pass # Replace with function body.

func _on_clear_button_pressed():
	pass # Replace with function body.


#------------------------------
# slider value -> label text
#------------------------------
func _on_param1_value_changed(value):
	param1_value.text = str(param1_slider.value)

func _on_param2_value_changed(value):
	param2_value.text = str(param2_slider.value)

func _on_param3_value_changed(value):
	param3_value.text = str(param3_slider.value)

func _on_param4_value_changed(value):
	param4_value.text = str(param4_slider.value)
