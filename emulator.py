import matlab.engine
import os
import json
from flask import Flask, request, jsonify, send_from_directory
# from flask_cors import CORS

app = Flask(__name__, static_url_path="/static")
eng = matlab.engine.start_matlab()
eng.cd(os.path.abspath("./matlab"), nargout=0)
port = 8088
# CORS(app)


@app.route('/')
def root():
    return send_from_directory('html/', 'index.html')


@app.route('/_next/<path:subpath>')
def next(subpath):
    return send_from_directory('html/_next/', subpath)


@app.route("/init", methods=["POST"])
def init():
    data = request.json
    try:
        eng.emulator_init(
            matlab.double(data["ue_size"]),
            matlab.double(data["rangeOfPosition"]),
            nargout=0,
        )
        return jsonify({"status": 1})
    except matlab.engine.MatlabExecutionError as e:
        print(e)
        return jsonify({"status": 1, "message": e.args[0]})


@app.route("/ourAlgorithm", methods=["POST"])
def ourAlgorithm():
    data = request.json
    try:
        data = eng.emulator_ourAlgorithm(
            data["minDataTransferRateOfUEAcceptable"] * (10**6),
            data["maxDataTransferRateOfUAVBS"] * (10**6),
            nargout=1,
        )
        return jsonify({"status": 1, "data": json.loads(data)})
    except matlab.engine.MatlabExecutionError as e:
        print(e)
        return jsonify({"status": 1, "message": e.args[0]})


@app.route("/spiralMBSPlacementAlgorithm", methods=["POST"])
def spiralMBSPlacementAlgorithm():
    data = request.json
    try:
        data = eng.emulator_spiralMBSPlacementAlgorithm(
            matlab.double(data["r_UAVBS"]),
            data["minDataTransferRateOfUEAcceptable"] * (10**6),
            data["maxDataTransferRateOfUAVBS"] * (10**6),
            nargout=1,
        )
        return jsonify({"status": 1, "data": json.loads(data)})
    except matlab.engine.MatlabExecutionError as e:
        print(e)
        return jsonify({"status": 1, "message": e.args[0]})


@app.route("/kmeans", methods=["POST"])
def kmeans():
    data = request.json
    try:
        data = eng.emulator_kmeans(
            matlab.double(data["index"]),
            matlab.double(data["k"]),
            data["minDataTransferRateOfUEAcceptable"] * (10**6),
            data["maxDataTransferRateOfUAVBS"] * (10**6),
            nargout=1,
        )
        return jsonify({"status": 1, "data": json.loads(data)})
    except matlab.engine.MatlabExecutionError as e:
        print(e)
        return jsonify({"status": 1, "message": e.args[0]})


@app.route("/random", methods=["POST"])
def random():
    data = request.json
    try:
        data = eng.emulator_random(
            matlab.double(data["rangeOfPosition"]),
            data["minDataTransferRateOfUEAcceptable"] * (10**6),
            data["maxDataTransferRateOfUAVBS"] * (10**6),
            nargout=1,
        )
        return jsonify({"status": 1, "data": json.loads(data)})
    except matlab.engine.MatlabExecutionError as e:
        print(e)
        return jsonify({"status": 1, "message": e.args[0]})


@app.route("/voronoi", methods=["POST"])
def voronoi():
    data = request.json
    try:
        data = eng.emulator_voronoi(
            matlab.double(data["r_UAVBS"]),
            data["minDataTransferRateOfUEAcceptable"] * (10**6),
            data["maxDataTransferRateOfUAVBS"] * (10**6),
            nargout=1,
        )
        return jsonify({"status": 1, "data": json.loads(data)})
    except matlab.engine.MatlabExecutionError as e:
        print(e)
        return jsonify({"status": 1, "message": e.args[0]})


if __name__ == "__main__":
    app.run(port=port, debug=True)
