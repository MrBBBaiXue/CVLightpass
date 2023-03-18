from flask import *


app = Flask(__name__, static_folder = './', static_url_path = '/')
app.config["JSON_AS_ASCII"] = False
mainpage_path = "webui/index.html"
is_debug = True

# Mainpage
@app.route('/')
def index():
    return app.send_static_file(mainpage_path)

# Fallback
@app.route('/<path:fallback>')
def fallback(fallback):
    if fallback == 'favicon.ico':
        return app.send_static_file(fallback)
    else:
        return app.send_static_file(mainpage_path)

# Test method
@app.route('/api/ping', methods=['GET'])
def api_ping():
    return 'pong';

# Process Image
@app.route('/api/upload', methods=['POST'])
def api_upload():
    method = request.values["method"]
    if method != None: # test on getting requests
        return jsonify('{} not implemented!'.format(method))
    return jsonify('Not implemented!');


# Startup
if __name__ == '__main__':
    app.run(host='0.0.0.0', port=27015, debug=is_debug)