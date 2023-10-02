from flask import Flask, request, jsonify


app = Flask(__name__)

@app.route('/api/echo', methods=['POST'])
def echo():
    data = request.get_json()
    return jsonify(data), 200


if __name__ == "__main__":
    app.run(debug=False)

