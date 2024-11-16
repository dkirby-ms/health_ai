import os

from typing import List
from azure.core.credentials import AzureKeyCredential
from openai import AzureOpenAIClient, ChatMessage, ChatCompletionOptions, AzureSearchChatDataSource, DataSourceAuthentication, DataSourceQueryType

class OpenAIChat:
    def __init__(self):
        self.endpoint = "https://hdi-openai-resource.openai.azure.com/"
        self.deployment_name = "gpt-35-turbo"
        self.search_endpoint = "https://ehisearchindex.search.windows.net"
        self.search_index = "customschemaindex"
        self.semantic_configuration = "customschemasemantic"
        self.openai_api_key = "set your Azure OpenAI key here"
        self.search_resource_key = "set your Azure Search API Key here"

    async def openai_request_async(self, question: str) -> 'ChatResponse':
        response = ChatResponse()

        try:
            credential = AzureKeyCredential(self.openai_api_key)
            azure_client = AzureOpenAIClient(self.endpoint, credential)
            chat_client = azure_client.get_chat_client(self.deployment_name)

            messages = [
                ChatMessage(role="system", content="You are a helpful assistant in a health care professional setting. Use data source customschemaindex for the context."),
                ChatMessage(role="user", content=question)
            ]

            options = ChatCompletionOptions()
            options.add_data_source(AzureSearchChatDataSource(
                endpoint=self.search_endpoint,
                index_name=self.search_index,
                authentication=DataSourceAuthentication.from_api_key(self.search_resource_key),
                strictness=4,
                top_n_documents=20,
                semantic_configuration=self.semantic_configuration,
                query_type=DataSourceQueryType("semantic")
            ))
            options.frequency_penalty = 0
            options.presence_penalty = 0
            options.max_tokens = 800
            options.temperature = 0.7
            options.top_p = 0.95

            completion = await chat_client.complete_chat_async(messages, options)

            response.content = completion.content[0].text

            on_your_data_context = completion.get_azure_message_context()
            if on_your_data_context and on_your_data_context.intent:
                response.intent = on_your_data_context.intent

            for citation in on_your_data_context.citations or []:
                response.citations.append(citation.content)

        except Exception as ex:
            print(f"An error occurred: {str(ex)}")
            response.content = "An error occurred while processing the request."

        return response

class ChatResponse:
    def __init__(self):
        self.content: str = ""
        self.intent: str = ""
        self.citations: List[str] = []
