from app import handler
import json

event = {"sex": "m", "pclass": 1}
event_json_str = json.dumps(event)
result = handler(event_json_str, context=None)
print(result["statusCode"])
print(result["body"])
