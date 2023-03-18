from flask import *


app = Flask(__name__, static_folder = './', static_url_path = '/')
app.config["JSON_AS_ASCII"] = False
mainpage_path = "webui/index.html"
favicon_path = "webui/favicon.ico"
is_debug = True

# Mainpage
@app.route('/')
def index():
    return app.send_static_file(mainpage_path)

# Fallback
@app.route('/<path:fallback>')
def fallback(fallback):
    if fallback == 'favicon.ico':
        return app.send_static_file(favicon_path)
    else:
        return app.send_static_file(mainpage_path)

# Test method
@app.route('/api/ping', methods=['GET'])
def api_ping():
    return 'pong';

# Upload Image
# image -> body -> API -> id
@app.route('/api/upload', methods=['POST'])
def api_upload():
    imgid = request.values["id"]
    print(imgid)
    img = request.files.get('file')
    path = '/data/' + img.filename
    img.save(path)
    return jsonify(id=imgid)


# Process Image
# params:
#   id: image to process
#   method: process method: retinex / darkbasc
#   algorithm param: xxx
#   return code:
#    404 if not found. 200 ok
@app.route('/api/process', methods=['GET'])
def api_process():
    method = request.values["method"]
    if method != None: # test on getting requests
        return jsonify('{} not implemented!'.format(method))
    return jsonify('Not implemented!');
    pass



# Startup
if __name__ == '__main__':
    app.run(host='0.0.0.0', port=27015, debug=is_debug)