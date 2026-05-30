# Glassdoor Big Data Pipeline on Microsoft Azure

> An end-to-end cloud-based big data processing pipeline that ingests, cleans, analyses, and visualises **16,281,039 Glassdoor employee reviews (3.6 GB)** using a medallion architecture on Microsoft Azure.

<p align="center">
  <img src="https://img.shields.io/badge/Cloud-Microsoft%20Azure-0078D4?logo=microsoftazure&logoColor=white" alt="Azure"/>
  <img src="https://img.shields.io/badge/Processing-Apache%20Spark-E25A1C?logo=apachespark&logoColor=white" alt="Spark"/>
  <img src="https://img.shields.io/badge/Language-Python-3776AB?logo=python&logoColor=white" alt="Python"/>
  <img src="https://img.shields.io/badge/Storage-Delta%20Lake-00ADD4" alt="Delta Lake"/>
  <img src="https://img.shields.io/badge/BI-Power%20BI-F2C811?logo=powerbi&logoColor=black" alt="Power BI"/>
</p>

---

## Table of Contents

1. [Project Overview](#project-overview)
2. [Academic Context](#academic-context)
3. [Architecture](#architecture)
4. [Technologies Used](#technologies-used)
5. [Dataset](#dataset)
6. [Data Layers (Medallion Architecture)](#data-layers-medallion-architecture)
7. [Methodology](#methodology)
8. [Implementation Details](#implementation-details)
9. [Results and Insights](#results-and-insights)
10. [Repository Structure](#repository-structure)
11. [Setup and Reproduction](#setup-and-reproduction)
12. [Security and Cost Considerations](#security-and-cost-considerations)
13. [Screenshots](#screenshots)
14. [Project Report](#project-report)
15. [Author](#author)

---

## Project Overview

This project implements a complete, production-style big data pipeline on Microsoft Azure to process and analyse a large dataset of Glassdoor employee reviews. The goal is to demonstrate the full lifecycle of a cloud big data solution: ingestion of raw data, distributed processing and cleaning, machine learning and natural language processing, analytical querying, and business-intelligence visualisation, alongside the supporting concerns of security, cost optimisation, and monitoring.

The pipeline processes over 16 million records and reduces them to a clean, analysis-ready dataset, then derives curated analytical tables that power a live Power BI dashboard connected to Azure Synapse Analytics.

---

## Academic Context

This repository contains the practical implementation for **Component 1 (60%)** of the module **LDS7005M – Big Data and Cloud Computing**, part of the MSc Data Science programme at **York St John University**.

| | |
|---|---|
| **Module** | LDS7005M – Big Data and Cloud Computing |
| **Assignment** | Component 1 – Optimizing Big Data Processing in the Cloud |
| **Cloud Platform** | Microsoft Azure |
| **Dataset** | Glassdoor Job Reviews (3.6 GB, 16,281,039 records) |

---

## Architecture

The solution follows the **Medallion Architecture** (Bronze → Silver → Gold) on a cloud-native Azure stack.

```
                    ┌─────────────────┐
                    │  Glassdoor CSV  │
                    │  3.6 GB / 16M   │
                    └────────┬────────┘
                             │
                    ┌────────▼────────┐
                    │ Azure Data      │   Ingestion
                    │ Factory         │
                    └────────┬────────┘
                             │
   ┌─────────────────────────▼─────────────────────────┐
   │            Azure Data Lake Storage Gen2            │
   │  ┌──────────┐    ┌──────────┐    ┌──────────┐      │
   │  │  BRONZE  │ →  │  SILVER  │ →  │   GOLD   │      │
   │  │   Raw    │    │ Cleaned  │    │ Curated  │      │
   │  └──────────┘    └──────────┘    └──────────┘      │
   └─────────────────────────┬─────────────────────────┘
                             │
                    ┌────────▼────────┐
                    │ Azure Databricks│   Processing
                    │ (PySpark / ML)  │   ML / NLP
                    └────────┬────────┘
                             │
                    ┌────────▼────────┐
                    │ Azure Synapse   │   Serverless SQL
                    │ Analytics       │
                    └────────┬────────┘
                             │
                    ┌────────▼────────┐
                    │    Power BI     │   Visualisation
                    │   Dashboard     │
                    └─────────────────┘

   Cross-cutting:  Azure Key Vault  •  Azure Monitor  •  Log Analytics
```

---

## Technologies Used

| Category | Technology |
|---|---|
| **Cloud Platform** | Microsoft Azure |
| **Ingestion** | Azure Data Factory (V2) |
| **Storage** | Azure Data Lake Storage Gen2 (ADLS Gen2) |
| **Processing** | Azure Databricks, Apache Spark (PySpark) |
| **Storage Format** | Delta Lake |
| **Data Warehouse** | Azure Synapse Analytics (Serverless SQL) |
| **Machine Learning** | Spark MLlib (Random Forest Regression) |
| **NLP / Sentiment** | VADER (Valence Aware Dictionary and sEntiment Reasoner) |
| **Visualisation** | Microsoft Power BI Desktop |
| **Security** | Azure Key Vault, Azure RBAC, Microsoft Entra ID |
| **Monitoring** | Azure Monitor, Log Analytics (KQL) |
| **Language** | Python 3, SQL, KQL |

---

## Dataset

| Attribute | Detail |
|---|---|
| **Name** | Glassdoor Job Reviews |
| **Source** | [Kaggle](https://www.kaggle.com/datasets/davidgauthier/glassdoor-job-reviews-2) |
| **Format** | CSV (`all_reviews.csv`) |
| **Size** | 3.6 GB |
| **Records** | 16,281,039 rows |
| **Columns** | 19 columns |
| **Data Types** | Structured (ratings), Semi-structured (status, dates), Unstructured (free-text reviews) |

> **Note:** The raw dataset is **not included** in this repository due to its size (3.6 GB) and source licensing. It can be downloaded directly from the Kaggle link above.

---

## Data Layers (Medallion Architecture)


| Layer | Description | Records | Availability |
|---|---|---|---|
| **Bronze** | Raw, unmodified ingested data | 16,281,039 | [Kaggle](https://kaggle.com) (3.6 GB) |
| **Silver** | Cleaned, deduplicated, type-cast, partitioned by year (Delta) | 9,508,621 | OneDrive (≈1.5 GB — see link below) |
| **Gold** | Curated analytical aggregate tables & visual dashboards | ~Hundreds | In this repo (`data/gold/`) & [Power BI](https://powerbi.com) |

The cleaning process removed **6,772,418 records** (duplicates, nulls in critical columns, and invalid out-of-range values).

### Accessing the Datasets & Dashboards

* **Raw Data (Bronze):** Available from its original [Kaggle Source](https://kaggle.com).
* **Cleaned Dataset (Silver):** Exceeds GitHub limits. Download from [OneDrive Silver Layer](https://sharepoint.com).
* **Aggregated Tables (Gold):** Included directly in this repository under `data/gold/`.
* **Interactive Analytics (Gold):** View the live [Power BI Dashboard](https://app.powerbi.com/groups/me/reports/aef47565-0174-47cb-8902-01e58a835687/d83bccb8a42d3b328146?experience=power-bi)


---

## Methodology

The project was implemented in the following stages:

**1. Ingestion** — A raw 3.6 GB CSV was ingested into the Bronze layer of ADLS Gen2 using an Azure Data Factory Copy pipeline, authenticated via the Data Factory's managed identity.

**2. Profiling** — The raw data was profiled in Databricks to quantify nulls, duplicates, and corrupted values before any cleaning decisions were made.

**3. Cleaning (Bronze → Silver)** — Using PySpark, rating columns were safely cast (`try_cast`), invalid and null records removed, duplicates dropped, dates standardised, text normalised, and the employment status field parsed into employment type and tenure. The result was written to the Silver layer in Delta Lake format, partitioned by year.

**4. Aggregation (Silver → Gold)** — Analysis-ready summary tables were computed (rating by year, sub-dimension averages, employment statistics, rating distribution, recommendation breakdown, tenure statistics) and stored in the Gold layer.

**5. Machine Learning** — A Random Forest regression model was trained to predict overall rating from six workplace sub-dimension scores, identifying the strongest drivers of employee satisfaction.

**6. Sentiment Analysis** — VADER sentiment scoring was applied to the free-text `pros` and `cons` columns.

**7. Querying** — Azure Synapse serverless SQL queried the Gold layer directly via `OPENROWSET` over the Delta tables, exposed through SQL views.

**8. Visualisation** — Power BI Desktop connected live to Synapse to build an interactive analytics dashboard.

---

## Implementation Details

### Data Cleaning (PySpark)
- Safe type casting with `try_cast` and `try_to_date` to handle corrupted values without job failure
- Programmatic column renaming to satisfy Delta Lake naming constraints (e.g. `Career Opportunities` → `Career_Opportunities`)
- Delta Lake format with year-based partitioning for query performance

### Machine Learning (Spark MLlib)
- **Model:** Random Forest Regressor (120 trees, max depth 10)
- **Features:** Career Opportunities, Compensation & Benefits, Work/Life Balance, Culture & Values, Diversity & Inclusion, Senior Management
- **Target:** Overall rating
- **Split:** 80/20 train/test, fixed seed for reproducibility

### Analytics (Synapse Serverless SQL)
- `OPENROWSET` queries over Delta-format Gold tables
- SQL views exposing each Gold table for clean Power BI consumption

---

## Results and Insights

| Metric | Result |
|---|---|
| **Raw records** | 16,281,039 |
| **Cleaned records** | 9,508,621 |
| **Random Forest RMSE** | 0.63 |
| **Random Forest R²** | 0.74 |
| **Strongest rating driver** | Culture & Values |
| **Weakest rating driver** | Compensation & Benefits |

**Key insights:**
- Average employee ratings rose steadily from ~3.15 (2010) to a peak of 3.77 (2022), with a slight dip to 3.69 in 2023.
- Four-star reviews are the most common rating.
- **Current employees rate their companies ~0.5 stars higher than former employees** (3.76 vs 3.27) — suggesting dissatisfaction builds before departure.
- **Culture & Values** is the strongest predictor of overall satisfaction, indicating that investment in workplace culture and leadership may improve ratings more than pay alone.

---

## Repository Structure

```
glassdoor-bigdata-azure/
│
├── README.md                       # This file
│
├── notebook/
│   └── glassdoor_pipeline.ipynb    # Full PySpark notebook (cleaning, ML, NLP)
│
├── sql/
│   └── synapse_queries.sql         # Synapse SQL views and analytical queries
│
├── powerbi/
│   └── Glassdoor_Dashboard.pbix    # Power BI dashboard (live Synapse connection)
│
├── data/
│   └── gold/                       # Curated Gold-layer analytical tables (CSV)
│       ├── gold_rating_by_year.csv
│       ├── gold_dimension_averages.csv
│       ├── gold_employment_stats.csv
│       ├── gold_rating_distribution.csv
│       ├── gold_recommend_breakdown.csv
│       └── gold_tenure_stats.csv
│
└── screenshots/                    # Pipeline evidence screenshots
    └── ...
```

---

## Setup and Reproduction

To reproduce this pipeline in your own Azure environment:

### Prerequisites
- An Azure subscription
- An Azure Databricks workspace
- An ADLS Gen2 storage account
- An Azure Synapse Analytics workspace
- Power BI Desktop

### Steps

**1. Provision storage**
Create an ADLS Gen2 storage account with a container `glassdoor-data` containing `bronze`, `silver`, and `gold` folders.

**2. Ingest the data**
Download the dataset from [Kaggle](https://www.kaggle.com/datasets/davidgauthier/glassdoor-job-reviews-2) and load `all_reviews.csv` into the `bronze` folder (via Azure Data Factory or direct upload).

**3. Run the notebook**
Import `notebook/glassdoor_pipeline.ipynb` into Databricks. Update the storage account name and provide credentials **via Azure Key Vault** (do not hard-code keys). Run all cells to generate the Silver and Gold layers.

**4. Set up Synapse**
Run `sql/synapse_queries.sql` in the Synapse serverless SQL pool to create the database and views over the Gold layer.

**5. Connect Power BI**
Open `powerbi/Glassdoor_Dashboard.pbix` and update the Synapse serverless endpoint connection, or connect a new report to `GoldDB`.

---

## Security and Cost Considerations

**Security**
- All credentials stored in **Azure Key Vault** — no secrets hard-coded
- **RBAC** with least-privilege role assignments (services granted only `Storage Blob Data Contributor`)
- Encryption at rest (AES-256) and in transit (TLS 1.2+)
- Azure platform compliance: ISO/IEC 27001, GDPR, SOC 2

> ⚠️ **Note:** The notebook in this repository uses a placeholder (`<storage account key>`) in place of any real credential. Never commit real storage keys or connection strings to a public repository.

**Cost Optimisation**
- Databricks single-node cluster with **120-minute auto-termination** to eliminate idle compute charges
- Synapse **serverless** SQL (pay-per-query) — total query cost remained under **£0.01**
- ADLS Gen2 **lifecycle management** to tier older data to cheaper storage

---

## Screenshots

Pipeline evidence screenshots are available in the [`screenshots/`](screenshots/) folder, covering:

- Data ingestion (ADLS Gen2, Data Factory pipeline runs)
- Databricks cluster and PySpark execution
- Data cleaning and profiling outputs
- Synapse SQL queries and results
- Power BI analytics dashboard
- Security configuration (Key Vault, RBAC, encryption)
- Cost management and monitoring (Azure Monitor, Log Analytics KQL)

---

## Project Report

The full academic report — including detailed methodology, architecture justification, analysis, and references — accompanies this repository as the primary submission deliverable for the module.

---

## Author

**Waseek Lareef**
MSc Data Science — York St John University (London Campus)

- IEEE-published researcher (NSCLC detection, ICECET 2025)
- Interests: Machine Learning, Cloud Computing, Data Engineering

---

<p align="center"><i>Built as part of the MSc Data Science programme at York St John University, 2026.</i></p>
