import json
import requests

API_KEY = "Set your key here"
ENDPOINT = "https://hdi-openai-resource.openai.azure.com/openai/deployments/gpt-4/chat/completions?api-version=2024-02-15-preview"

def openai_request(question):
    headers = {
        "Content-Type": "application/json",
        "api-key": API_KEY
    }
    payload = {
        "messages": [
            {
                "role": "system",
                "content": [
                    {
                        "type": "text",
                        "text": "You are an AI assistant that helps people find information."
                    }
                ]
            },
            {
                "role": "user",
                "content": [
                    {
                        "type": "text",
                        "text": question
                    }
                ]
            }
        ],
        "temperature": 0.7,
        "top_p": 0.95,
        "max_tokens": 800,
        "stream": False
    }

    response = requests.post(ENDPOINT, headers=headers, data=json.dumps(payload))

    if response.status_code == 200:
        response_data = response.json()
        return response_data.get('choices', [{}])[0].get('message', {}).get('content', None)
    else:
        print(f"Error: {response.status_code}, {response.reason}")
        return None
