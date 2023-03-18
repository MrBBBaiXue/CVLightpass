extends Node

var w0 : float = 0.0
var t0 : float = 0.0
var a0 : float = 0.0
var b0 : float = 0.0

var imagelist : Node = null
@onready var image_scene = preload("res://image.tscn")


func add_image(path) -> void:
	# Init image node.
	print(path)
	var node = image_scene.instantiate()
	node.image_path = path
	if imagelist != null:
		imagelist.add_child(node)	


func send_image() -> void:
	pass
