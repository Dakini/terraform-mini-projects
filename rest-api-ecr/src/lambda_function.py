import json
from classifier import classify


def lambda_handler(event, context):

    try:
        data = json.loads(event["body"])

        label = data["label"] if "label" in data else ""

        results = classify(label)

        return json.dumps(results) if results else json.dumps([])
    except Exception as e:
        return str(e)
