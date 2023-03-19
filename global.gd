extends Node

# Darkbasc
var w : float = 0.0
var r : float = 0.0
var maxV1 : float = 0.0

# Retinex
var sigma = []

var imagelist : Node = null
@onready var image_scene = preload("res://image.tscn")

const api = "http://127.0.0.1:27015"

func add_image(path) -> void:
	# Init image node.
	print(path)
	var id = str(floorf(Time.get_unix_time_from_system()))
	var node = image_scene.instantiate()
	node.image_path = path
	node.image_id = id
	# Display Image
	node.img = Image.load_from_file(path)
	var texture = ImageTexture.create_from_image(node.img)
	node.get_node("%FileID").text = node.image_id
	node.get_node("%TextureRect").texture = texture
	if imagelist != null:
		imagelist.add_child(node)
		Global.upload_image(id, path)


func add_image_from_img(id, img) -> void:
	var node = image_scene.instantiate()
	node.image_id = id
	# Display Image
	node.img = img
	var texture = ImageTexture.create_from_image(img)
	node.get_node("%FileID").text = node.image_id
	node.get_node("%TextureRect").texture = texture
	if imagelist != null:
		imagelist.add_child(node)


func upload_image(id: String, path: String) -> void:
	var f = FileAccess.open(path, FileAccess.READ)
	var content = f.get_buffer(f.get_length())
	var body = PackedByteArray()
	body.append_array("\r\n--BodyBoundary\r\n".to_utf8_buffer())
	body.append_array(("Content-Disposition: form-data; name=\"file\"; filename=\"%s.png\"\r\n" % id).to_utf8_buffer())
	body.append_array("Content-Type: image/png\r\n\r\n".to_utf8_buffer())
	body.append_array(content)
	body.append_array("\r\n--BodyBoundary--\r\n".to_utf8_buffer())
	var headers = [
		"Content-Type: multipart/form-data; boundary=BodyBoundary"
	]
	var request = HTTPRequest.new()
	add_child(request)
	request.request_completed.connect(func(result, response_code, headers, body):
		if response_code == HTTPClient.RESPONSE_OK:
			var response = body.get_string_from_utf8()
			print(response)
		)
	var error = request.request_raw(api + ('/api/upload?id=%s' % id), headers, HTTPClient.METHOD_POST, body)
	if error != OK:
		push_error(error)
	pass

func process_image(id, method) -> void:
	var process_request = HTTPRequest.new()
	add_child(process_request)
	process_request.request_completed.connect(func(result, response_code, headers, body):
		var response = JSON.parse_string(body.get_string_from_utf8())
		print(response)
		download_image(response["id"])
		)
	var url = Global.api + ("/api/process?id=%s&method=%s" % [id, method])
	# Pass params in body
	var body = ""
	if method == "darkbasc":
		var dict = { "r":r, "eps":0.001, "w": w, "maxV1":maxV1 }
		body = JSON.stringify(dict)
	elif method == "retinex":
		var dict = {"sigma_list": sigma}
		body = JSON.stringify(dict)
	var error = process_request.request(url, PackedStringArray(), HTTPClient.METHOD_GET, body)
	if error != OK:
		push_error(error)


func download_image(id) -> void:
	var img_request = HTTPRequest.new()
	add_child(img_request)
	img_request.request_completed.connect(func(result, response_code, headers, body):
		var image = Image.new()
		if response_code == HTTPClient.RESPONSE_NOT_FOUND:
			print("Image not found on server!")
			return
		var error = image.load_png_from_buffer(body)
		if error != OK:
			push_error("Cannot load image.")
		add_image_from_img(id, image)
		)
	var url = Global.api + ("/api/image?id=%s" % id)
	var error = img_request.request(url)
	if error != OK:
		push_error(error)
