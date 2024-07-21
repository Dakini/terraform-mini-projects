from joblib import load
import json


def handler(event, context):

    body = event  # json.loads(event)
    model = load("titanic_model.sav")

    sex = body["sex"]
    pclass = body["pclass"]
    X = [
        [
            pclass,
            int(sex != "m"),
            int(sex == "m"),
        ]
    ]
    survived = model.predict(X)

    return {
        "statusCode": 200,
        "body": "not survived" if survived == 0 else "survived",
        "input-sex": sex,
        "input-pclass": pclass,
        "test": "rawr",
    }
