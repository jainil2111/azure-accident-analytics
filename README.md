# Azure Accident Analytics

End-to-end data engineering pipeline on Microsoft Azure processing 7.7 million US traffic accident records (2016–2023).

---

## Architecture

![System Architecture](docs/01_azure_architecture_v2.png)

---

## Dataset

| Property | Value |
|---|---|
| Source | [US Accidents (2016–2023) — Kaggle](https://www.kaggle.com/datasets/sobhanmoosavi/us-accidents/data) |
| Size | 3 GB, 7,728,394 rows, 46 columns |
| Coverage | 49 US states, February 2016 – March 2023 |

---

## Tech Stack

| Layer | Technology |
|---|---|
| Storage | Azure Data Lake Storage Gen2 |
| Processing | Azure Databricks (Apache Spark 3.4.1) |
| Orchestration | Azure Data Factory |
| Serving | Azure SQL Server + SQL Database |
| Visualization | Power BI Desktop |
| Infrastructure | Terraform (IaaC) |
| Version Control | GitHub |

---

## Repository Structure

```
azure-accident-analytics/
├── notebooks/
│   ├── 01_ingest_explore.ipynb
│   ├── 02_clean_transform.ipynb
│   └── 03_load_sql.ipynb
├── sql/
│   └── create_tables.sql
├── powerbi/
│   └── us_accidents_dashboard.pbix
├── adf/
│   └── pipeline_accident_analytics.json
├── terraform/
│   └── main.tf
├── docs/
│   ├── 01_azure_architecture_v2.png
│   ├── 02_adf_pipeline.png
│   ├── 03_data_flow.png
│   └── 04_azure_resources.png
├── screenshots/
│   ├── ingestion/
│   ├── cleaning/
│   ├── serving/
│   ├── dashboards/
│   └── adf/
└── README.md
```

---

## Notebooks

| Notebook | Description |
|---|---|
| `01_ingest_explore.ipynb` | Mount ADLS, read CSV, profile data, null analysis |
| `02_clean_transform.ipynb` | Clean data, handle nulls, build 5 aggregate tables + agg_master, write Parquet |
| `03_load_sql.ipynb` | Load all 6 tables from ADLS to Azure SQL DB via JDBC |

---

## Pipeline Orchestration (Azure Data Factory)

![ADF Pipeline](docs/02_adf_pipeline.png)

The pipeline is orchestrated using Azure Data Factory (`adf/pipeline_accident_analytics.json`).

- **Trigger:** Manual — run on demand via ADF Studio
- **Flow:** `act_ingest` → `act_clean` → `act_load_sql`
- Each activity runs the corresponding Databricks notebook in sequence
- If any notebook fails, the pipeline stops and downstream activities are skipped

To import the pipeline into your own ADF instance, upload `adf/pipeline_accident_analytics.json` via ADF Studio → Author → Import from pipeline template.

---

## Data Flow

![Data Flow](docs/03_data_flow.png)

---

## Azure Resources

![Azure Resources](docs/04_azure_resources.png)

| Resource | Name | Details |
|---|---|---|
| Resource Group | data-engineering-project | Canada Central |
| Storage Account | deprojectstorage1 | ADLS Gen2, raw + processed containers |
| Databricks Workspace | de-project-databricks | Standard tier, Runtime 13.3 LTS |
| Databricks Cluster | de-project-cluster | Standard_D4ds_v5, 16 GB, 4 cores |
| SQL Server | deprojectserver2026 | deprojectserver2026.database.windows.net |
| SQL Database | de-project-db | Free tier, 6 tables |
| Data Factory | adf-accident-analytics | Manual trigger, 1 pipeline |

---

## Aggregate Tables (Azure SQL Database)

| Table | Rows | Description |
|---|---|---|
| `agg_by_state` | 49 | Total accidents and avg severity per state |
| `agg_by_severity` | 4 | Accident count per severity level |
| `agg_by_time` | 84 | Accidents by year and month |
| `agg_by_weather` | 20 | Top 20 weather conditions and avg severity |
| `agg_by_hour` | 24 | Accidents by hour of day |
| `agg_master` | ~400K | Master fact table — State · Severity · Year · Hour · Weather combined for interactive Power BI cross-filtering |

---

## Interactive Power BI Dashboard

Built on `agg_master` — a single denormalized fact table combining all 5 dimensions enabling full cross-filtering across all visuals and pages simultaneously.

**Page 1 — National Overview**
- KPI cards: Total Accidents · States Covered · Avg Severity · Peak Hour
- Bar chart: Top 10 states by accidents
- Donut chart: Severity distribution
- Slicers: State · Severity · Year

**Page 2 — Time Analysis**
- Line chart: Accident trend by year (2016–2023)
- Bar chart: Accidents by hour of day
- Slicers: State · Severity · Year

**Page 3 — Weather Analysis**
- Bar chart: Top 10 weather conditions by accidents
- Bar chart: Average severity by weather condition
- Slicers: State · Severity · Year

---

## Infrastructure as Code (Terraform)

All Azure resources are defined in `terraform/main.tf`. To recreate the entire environment:

```bash
cd terraform
terraform init
terraform plan
terraform apply
```

Resources managed: resource group · storage account (ADLS Gen2) · Databricks workspace · SQL server · SQL database · Azure Data Factory

---

## Key Findings

- California has the most accidents with 1.74 million — 22% of all US accidents
- 79% of accidents are Severity 2 (moderate impact on traffic)
- Peak accident hours are 7am, 8am, 4pm and 5pm — rush hours
- Fair weather has the most accidents (2.5M) — people drive carelessly in good conditions
- Accidents grew steadily from 2016 to 2022 then dropped in 2023

---

## Pipeline Setup (Manual)

1. Upload `US_Accidents_March23.csv` to ADLS Gen2 `raw` container
2. Run `notebooks/01_ingest_explore.ipynb` to explore data
3. Run `notebooks/02_clean_transform.ipynb` to clean and transform
4. Run `notebooks/03_load_sql.ipynb` to load all tables to Azure SQL Database
5. Open `powerbi/us_accidents_dashboard.pbix` in Power BI Desktop

Or trigger the full pipeline via Azure Data Factory → Add trigger → Trigger now.

---

## Team

| Member | Role |
|---|---|
| Jainil Malaviya | Ingestion and Infrastructure Lead |
| Rohan | Transformation Lead |
| Jayabal | Serving and Visualization Lead |
