---
page_type: sample
languages:
- azdeveloper
- python
- bicep
- typescript
- html
products:
- azure
- azure-cosmos-db
- azure-container-apps
- azure-container-registry
- azure-monitor
- azure-pipelines
urlFragment: todo-python-mongo-aca
name: Containerized React Web App with Python API and MongoDB on Azure
description: A complete ToDo app with Python FastAPI and Azure Cosmos API for MongoDB for storage. Uses Azure Developer CLI (azd) to build, deploy, and monitor
---
<!-- YAML front-matter schema: https://review.learn.microsoft.com/en-us/help/contribute/samples/process/onboarding?branch=main#supported-metadata-fields-for-readmemd -->

# AHDS GenAI

[![Open in GitHub Codespaces](https://img.shields.io/static/v1?style=for-the-badge&label=GitHub+Codespaces&message=Open&color=brightgreen&logo=github)](https://codespaces.new/azure-samples/todo-python-mongo-aca)
[![Open in Dev Container](https://img.shields.io/static/v1?style=for-the-badge&label=Dev+Containers&message=Open&color=blue&logo=visualstudiocode)](https://vscode.dev/redirect?url=vscode://ms-vscode-remote.remote-containers/cloneInVolume?url=https://github.com/azure-samples/todo-python-mongo-aca)

A blueprint for deploying AHDS with APIM frontend and using it with LMs.

Currently includes a stub TODO application that will be replaced with a custom frontend.

!["Screenshot of deployed ToDo app"](assets/web.png)

<sup>Screenshot of the deployed ToDo app</sup>

### Prerequisites
> This template will create infrastructure and deploy code to Azure. If you don't have an Azure Subscription, you can sign up for a [free account here](https://azure.microsoft.com/free/). Make sure you have contributor role to the Azure subscription.

The following prerequisites are required to use this application. Please ensure that you have them all installed locally.

- [Azure Developer CLI](https://aka.ms/azd-install)
- [Python (3.8+)](https://www.python.org/downloads/) - for the API backend
- [Node.js with npm (18.17.1+)](https://nodejs.org/) - for the Web frontend
- [Docker](https://docs.docker.com/get-docker/)

### Quickstart
To learn how to get started with any template, follow the steps in [this quickstart](https://learn.microsoft.com/azure/developer/azure-developer-cli/get-started?tabs=localinstall&pivots=programming-language-python) with this template(`Azure-Samples/todo-python-mongo-aca`).

This quickstart will show you how to authenticate on Azure, initialize using a template, provision infrastructure and deploy code on Azure via the following commands:

```bash
# Log in to azd. Only required once per-install.
azd auth login

# First-time project setup. Initialize a project in the current directory, using this template. 
azd init --template Azure-Samples/todo-python-mongo-aca

# Provision and deploy to Azure
azd up
```

> NOTE: This template may only be used with the following Azure locations:
>
> - Australia East
> - Brazil South
> - Canada Central
> - Central US
> - East Asia
> - East US
> - East US 2
> - Germany West Central
> - Japan East
> - Korea Central
> - North Central US
> - North Europe
> - South Central US
> - UK South
> - West Europe
> - West US
>
> If you attempt to use the template with an unsupported region, the provision step will fail.

### Application Architecture

This application utilizes the following Azure resources:

- [**Azure Container Apps**](https://docs.microsoft.com/azure/container-apps/) to host the Web frontend and API backend
- [**Azure Cosmos DB API for MongoDB**](https://docs.microsoft.com/azure/cosmos-db/mongodb/mongodb-introduction) for storage
- [**Azure Monitor**](https://docs.microsoft.com/azure/azure-monitor/) for monitoring and logging
- [**Azure Key Vault**](https://docs.microsoft.com/azure/key-vault/) for securing secrets

Here's a high level architecture diagram that illustrates these components. Notice that these are all contained within a single [resource group](https://docs.microsoft.com/azure/azure-resource-manager/management/manage-resource-groups-portal), that will be created for you when you create the resources.

*WIP*

### Cost of provisioning and deploying this template
This template provisions resources to an Azure subscription that you will select upon provisioning them. Refer to the [Pricing calculator for Microsoft Azure](https://azure.microsoft.com/pricing/calculator/) to estimate the cost you might incur when this template is running on Azure and, if needed, update the included Azure resource definitions found in `infra/main.bicep` to suit your needs.

### Application Code

This template is structured to follow the [Azure Developer CLI](https://aka.ms/azure-dev/overview). You can learn more about `azd` architecture in [the official documentation](https://learn.microsoft.com/azure/developer/azure-developer-cli/make-azd-compatible?pivots=azd-create#understand-the-azd-architecture).

### Next Steps

At this point, you have a complete application deployed on Azure. But there is much more that the Azure Developer CLI can do. These next steps will introduce you to additional commands that will make creating applications on Azure much easier. Using the Azure Developer CLI, you can setup your pipelines, monitor your application, test and debug locally.

> Note: Needs to manually install [setup-azd extension](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.azd) for Azure DevOps (azdo).

- [`azd pipeline config`](https://learn.microsoft.com/azure/developer/azure-developer-cli/configure-devops-pipeline?tabs=GitHub) - to configure a CI/CD pipeline (using GitHub Actions or Azure DevOps) to deploy your application whenever code is pushed to the main branch. 

- [`azd monitor`](https://learn.microsoft.com/azure/developer/azure-developer-cli/monitor-your-app) - to monitor the application and quickly navigate to the various Application Insights dashboards (e.g. overview, live metrics, logs)

- [Run and Debug Locally](https://learn.microsoft.com/azure/developer/azure-developer-cli/debug?pivots=ide-vs-code) - using Visual Studio Code and the Azure Developer CLI extension

- [`azd down`](https://learn.microsoft.com/azure/developer/azure-developer-cli/reference#azd-down) - to delete all the Azure resources created with this template 

- [Enable optional features, like APIM](./OPTIONAL_FEATURES.md) - for enhanced backend API protection and observability

### Additional `azd` commands

The Azure Developer CLI includes many other commands to help with your Azure development experience. You can view these commands at the terminal by running `azd help`. You can also view the full list of commands on our [Azure Developer CLI command](https://aka.ms/azure-dev/ref) page.

## Security

### Roles

This template creates a [managed identity](https://docs.microsoft.com/azure/active-directory/managed-identities-azure-resources/overview) for your app inside your Azure Active Directory tenant, and it is used to authenticate your app with Azure and other services that support Azure AD authentication like Key Vault via access policies. You will see principalId referenced in the infrastructure as code files, that refers to the id of the currently logged in Azure Developer CLI user, which will be granted access policies and permissions to run the application locally. To view your managed identity in the Azure Portal, follow these [steps](https://docs.microsoft.com/azure/active-directory/managed-identities-azure-resources/how-to-view-managed-identity-service-principal-portal).

### Key Vault

This template uses [Azure Key Vault](https://docs.microsoft.com/azure/key-vault/general/overview) to securely store your Cosmos DB connection string for the provisioned Cosmos DB account. Key Vault is a cloud service for securely storing and accessing secrets (API keys, passwords, certificates, cryptographic keys) and makes it simple to give other Azure services access to them. As you continue developing your solution, you may add as many secrets to your Key Vault as you require.

## Reporting Issues and Feedback

If you have any feature requests, issues, or areas for improvement, please [file an issue](https://aka.ms/azure-dev/issues). To keep up-to-date, ask questions, or share suggestions, join our [GitHub Discussions](https://aka.ms/azure-dev/discussions). You may also contact us via AzDevTeam@microsoft.com.

# Use case flow

**Start with the system of record data sources. These can be:** 
* EHRs (Epic, Oracle Health, etc.)
* Ancillary clinical systems, such as radiology (imaging) information system (RIS), laboratory management IS (LMIS), picture archiving and communication system (PACS), vendor neutral archive (VNA) of imaging data.
* Integration (interface) engines

**Extract data in one of the common healthcare data formats (HL7v2, CDA/CCD, FHIR), DICOM (?), or unstructured/semi-structured data (CSV, TSV, PDF, TXT, etc.)**

**Ingest data into Azure Health Data Services**
* Via healthcare APIs (FHIR, DICOM?)
* Via bulk import into healthcare APIs
* Copy into ADLSv2 and ingest into healthcare API

**Ingest data into Microsoft Fabric**
* Export from FHIR, DICOM and ingest into Lakehouse (Healthcare Solution for Fabric)
* Ingest data from storage into Fabric Lakehouse

**Transform and harmonize data using Medallion architecture using Healthcare Solution**

**Demonstrate analytics capabilities:**
* Notebook
* SQL/Spark
* Power BI visualizations

**Demonstrate ML (AutoML) on discrete (structured) data**

**Demonstrate GenAI (Copilot) on text data.**
* Include structured data?

**Demonstrate natural language question understanding and translation into**
* SQL queries
* FHIR interactions
