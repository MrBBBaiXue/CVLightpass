extends Node

var w0 : float = 0.0
var t0 : float = 0.0
var a0 : float = 0.0
var b0 : float = 0.0

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
	if imagelist != null:
		imagelist.add_child(node)
		upload_image(id, path)


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


func download_image(id) -> void:
	
	pass
