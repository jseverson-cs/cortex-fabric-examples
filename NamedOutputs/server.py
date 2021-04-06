import json
import time
from flask import Flask, request
app = Flask(__name__)

@app.route('/skills/a', methods = ['POST'])
def skilla():
    if request.method == 'POST':
      reqBody = request.get_json(force=True)
      if reqBody:
        payload = reqBody.get('payload')
        if payload:
          claim_id = payload.get('claim_id')
          if claim_id % 2 == 0:
            return json.dumps({"outputName": "success","payload":{ "message": f'Processed skill a for claim id {claim_id}', "claim_id": claim_id }})    
          else:
            return json.dumps({"outputName": "error","payload":{ "message": f'Error processing skill a for claim id {claim_id}'}})

@app.route('/skills/b', methods = ['POST'])
def skillb():
    if request.method == 'POST':
      reqBody = request.get_json(force=True)
      if reqBody:
        payload = reqBody.get('payload')
        if payload:
          m = payload.get('message')
          claim_id = payload.get('claim_id')
          if claim_id % 3 == 0:
            return json.dumps({"outputName": "success","payload":{ "message": f'{m} Processed skill b for claim id {claim_id}', "claim_id": claim_id}})    
          else:
            return json.dumps({"outputName": "error","payload":{ "message": f'Error processing skill b for claim id {claim_id}'}})

@app.route('/skills/c', methods = ['POST'])
def skillc():
    if request.method == 'POST':
      reqBody = request.get_json(force=True)
      if reqBody:
        payload = reqBody.get('payload')
        if payload:
          m = payload.get('message')
          claim_id = payload.get('claim_id')
          if claim_id > 10:
            return json.dumps({"outputName": "success","payload":{ "message": f'{m} Processed skill c for claim id {claim_id}', "claim_id": claim_id}})    
          else:
            return json.dumps({"outputName": "error","payload":{ "message": f'Error processing skill c for claim id {claim_id}'}})

@app.route('/error', methods = ['POST'])
def error():
    if request.method == 'POST':
      reqBody = request.get_json(force=True)
      if reqBody:
        payload = reqBody.get('payload')
        if payload:
          m = payload.get('message')
          if "Error" in m:
            return json.dumps({"outputName": "output","payload":{ "error": m }})
          else: 
            return json.dumps({"outputName": "output","payload": payload })

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)
