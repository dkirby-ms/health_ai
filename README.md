# AHDS GenAI

[![Open in GitHub Codespaces](https://img.shields.io/static/v1?style=for-the-badge&label=GitHub+Codespaces&message=Open&color=brightgreen&logo=github)](https://codespaces.new/azure-samples/todo-python-mongo-aca)
[![Open in Dev Container](https://img.shields.io/static/v1?style=for-the-badge&label=Dev+Containers&message=Open&color=blue&logo=visualstudiocode)](https://vscode.dev/redirect?url=vscode://ms-vscode-remote.remote-containers/cloneInVolume?url=https://github.com/azure-samples/todo-python-mongo-aca)

A blueprint for deploying AHDS with APIM frontend and using it with LMs.

## Use cases

### System of record data sources

- EHRs (Epic, Oracle Health, etc.)
- Ancillary clinical systems, such as radiology (imaging) information system (RIS), laboratory management IS (LMIS), picture archiving and communication system (PACS), vendor neutral archive (VNA) of imaging data.
- Integration (interface) engines

### Extract data in one of the common healthcare data formats (HL7v2, CDA/CCD, FHIR), DICOM (?), or unstructured/semi-structured data (CSV, TSV, PDF, TXT, etc.)

### Ingest data into Azure Health Data Services

- Via healthcare APIs (FHIR, DICOM?)
- Via bulk import into healthcare APIs
- Copy into ADLSv2 and ingest into healthcare API

### Ingest data into Microsoft Fabric

- Export from FHIR, DICOM and ingest into Lakehouse (Healthcare Solution for Fabric)
- Ingest data from storage into Fabric Lakehouse

### Transform and harmonize data using Medallion architecture using Healthcare Solution

### Demonstrate analytics capabilities

- Notebook
- SQL/Spark
- Power BI visualizations

### Demonstrate ML (AutoML) on discrete (structured) data

### Demonstrate GenAI (Copilot) on text data.

- Include structured data?

### Demonstrate natural language question understanding and translation into

- SQL queries
- FHIR interactions

## Prerequisites

The following prerequisites are required to use this application. Please ensure that you have them all installed locally if you wish to use the sample code.

- [Azure Developer CLI](https://aka.ms/azd-install)
- [Python (3.8+)](https://www.python.org/downloads/) - for the API backend
- [Node.js with npm (18.17.1+)](https://nodejs.org/) - for the Web frontend
- [Docker](https://docs.docker.com/get-docker/)

## Quickstart

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
- [**Azure Monitor**](https://docs.microsoft.com/azure/azure-monitor/) for monitoring and logging
- [**Azure Key Vault**](https://docs.microsoft.com/azure/key-vault/) for securing secrets
- [**Azure Health Data Services**](https://learn.microsoft.com/azure/healthcare-apis/health-data-services-get-started)

### Next Steps

- [`azd pipeline config`](https://learn.microsoft.com/azure/developer/azure-developer-cli/configure-devops-pipeline?tabs=GitHub) - to configure a CI/CD pipeline (using GitHub Actions or Azure DevOps) to deploy your application whenever code is pushed to the main branch. 

- [`azd monitor`](https://learn.microsoft.com/azure/developer/azure-developer-cli/monitor-your-app) - to monitor the application and quickly navigate to the various Application Insights dashboards (e.g. overview, live metrics, logs)

- [Run and Debug Locally](https://learn.microsoft.com/azure/developer/azure-developer-cli/debug?pivots=ide-vs-code) - using Visual Studio Code and the Azure Developer CLI extension

- [`azd down`](https://learn.microsoft.com/azure/developer/azure-developer-cli/reference#azd-down) - to delete all the Azure resources created with this template

- [Enable optional features, like APIM](./OPTIONAL_FEATURES.md) - for enhanced backend API protection and observability
