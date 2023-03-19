from flask import *
import os
import json
import cv2
from datetime import datetime
from algorithms.retinex import *
from algorithms.darkbasc import *

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
    print("Upload image id: {}".format(imgid))
    img = request.files.get('file')
    path = '.\\data\\' + img.filename
    img.save(path)
    return jsonify(id=imgid)


# Process Image
# params:
#   id: image to process
#   method: process method: retinex / darkbasc
#   algorithm param: body
#   return code:
#    404 if not found.
@app.route('/api/process', methods=['GET'])
def api_process():
    imgid = request.values["id"]
    method = request.values["method"]
    path = '.\\data\\' + imgid + '.png'
    img = cv2.imread(path)
    if method != None:
        if method == "darkbasc":
            # Get image id from param in url,
            # get algorithm params in request body
            config = json.loads(request.get_data(as_text=True))
            img_darkbasc = deHaze(img / 255.0,
                                   r=int(config['r']), eps=float(config['eps']), w=float(config['w']), maxV1=float(config['maxV1'])
                                   ) * 255
            savid = str(int(datetime.timestamp(datetime.now())))
            savpath = '.\\data\\' + savid + '.png'
            cv2.imwrite(savpath, img_darkbasc)
            return jsonify(id=savid)
        if method == "retinex":
            config = json.loads(request.get_data(as_text=True))
            print('Retinex autoMSRCR processing......')
            img_amsrcr = automatedMSRCR(img, config['sigma_list'])
            savid = str(int(datetime.timestamp(datetime.now())))
            savpath = '.\\data\\' + savid + '.png'
            cv2.imwrite(savpath, img_amsrcr)
            return jsonify(id=savid)



@app.route('/api/image', methods=['GET'])
def api_image():
    imgid = request.values["id"]
    path = './data/' + imgid + '.png'
    if os.path.exists(path):
        return app.send_static_file(path)
    else:
        abort(404)


# Startup
if __name__ == '__main__':
    app.run(host='0.0.0.0', port=27015, debug=is_debug)