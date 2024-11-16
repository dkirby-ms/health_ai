import os
import asyncio
import openai
import dotenv

dotenv.load_dotenv()
openai.api_base = os.environ["OPENAI_API_BASE"]

from azure.core.credentials import AzureKeyCredential
from openai import OpenAIClient, ChatMessage, ChatCompletionOptions
from openai.chat import ChatClient
from azure.search.documents import SearchClient
from azure.search.documents.indexes.models import SearchIndex
from azure.search.documents.indexes.models import SearchIndexClient
from azure.search.documents.indexes.models import SearchIndexerClient

class OpenAIChat:
    def __init__(self):
        self.endpoint = "https://hdi-openai-resource.openai.azure.com/"
        self.deployment_name = "gpt-35-turbo"
        self.search_endpoint = "https://ehisearchindex.search.windows.net"
        self.search_index = "customschemaindex"
        self.semantic_configuration = "customschemasemantic"
        self.openai_api_key = "set your Azure OpenAI key here"
        self.search_resource_key = "set your Azure Search API Key here"

    async def openai_request_async(self, question):
        response = ChatResponse()

        try:
            credential = AzureKeyCredential(self.openai_api_key)
            azure_client = OpenAIClient(endpoint=self.endpoint, credential=credential)
            chat_client = azure_client.get_chat_client(self.deployment_name)

            messages = [
                ChatMessage(role="system", content="You are a helpful assistant in a health care professional setting. Use data source customschemaindex for the context."),
                ChatMessage(role="user", content=question)
            ]

            options = ChatCompletionOptions(
                data_sources=[
                    {
                        "endpoint": self.search_endpoint,
                        "index_name": self.search_index,
                        "authentication": {"api_key": self.search_resource_key},
                        "strictness": 4,
                        "top_n_documents": 20,
                        "semantic_configuration": self.semantic_configuration,
                        "query_type": "semantic"
                    }
                ],
                frequency_penalty=0,
                presence_penalty=0,
                max_tokens=800,
                temperature=0.7,
                top_p=0.95
            )

            completion = await chat_client.complete_chat_async(messages, options)
            response.content = completion.choices[0].message.content

            if completion.choices[0].message.context and completion.choices[0].message.context.intent:
                response.intent = completion.choices[0].message.context.intent

            for citation in completion.choices[0].message.context.citations:
                response.citations.append(citation.content)

        except Exception as ex:
            print(f"An error occurred: {ex}")
            response.content = "An error occurred while processing the request."

        return response

class ChatResponse:
    def __init__(self):
        self.content = ""
        self.intent = ""
        self.citations = []

# Example usage
# async def main():
#     chat = OpenAIChat()
#     response = await chat.openai_request_async("What is the weather today?")
#     print(response.content)

# asyncio.run(main())
