import aiohttp
import json

class OpenAIRequest:
    API_KEY = "Set your key here"
    ENDPOINT = "https://hdi-openai-resource.openai.azure.com/openai/deployments/gpt-4/chat/completions?api-version=2024-02-15-preview"

    @staticmethod
    async def openai_request_async(question):
        headers = {
            "api-key": OpenAIRequest.API_KEY,
            "Content-Type": "application/json"
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

        async with aiohttp.ClientSession() as session:
            async with session.post(OpenAIRequest.ENDPOINT, headers=headers, json=payload) as response:
                if response.status == 200:
                    response_data = await response.json()
                    return response_data["choices"][0]["message"]["content"]
                else:
                    print(f"Error: {response.status}, {response.reason}")
                    return None
