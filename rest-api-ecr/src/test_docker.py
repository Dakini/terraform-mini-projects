import requests
import json
import os

url = os.getenv("INVOKE_ARN")
event = {"body": '{"label": "Angelina Jolie"}'}
# Convert the payload dictionary to a JSON string
print(json.dumps(event))
response = requests.post(url, json=event)

print("Status Code:", response.status_code)
print("Status content", response.json())
