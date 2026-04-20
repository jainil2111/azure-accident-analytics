# Azure Accident Analytics

End-to-end data engineering pipeline on Microsoft Azure processing 7.7 million US traffic accident records (2016–2023).

---

## Architecture

```
Raw CSV → Azure Data Lake Storage Gen2 → Azure Databricks (PySpark) → Azure SQL Database → Power BI
                                                    ↑
                                        Azure Data Factory (Orchestration)
```

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
| Serving | Azure SQL Database |
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
│   └── architecture_diagram.png
├── pipeline_screenshot/
│   ├── 1.ingestion/
│   ├── 2.cleaning/
│   ├── 3.serving/
│   └── 4.orchestration/
└── README.md
```

---

## Notebooks

| Notebook | Description |
|---|---|
| `01_ingest_explore.ipynb` | Mount ADLS, read CSV, profile data, null analysis |
| `02_clean_transform.ipynb` | Clean data, handle nulls, build 5 aggregate tables, write Parquet |
| `03_load_sql.ipynb` | Load aggregate tables from ADLS to Azure SQL DB via JDBC |

---

## Pipeline Orchestration (Azure Data Factory)

The pipeline is fully automated using Azure Data Factory (`adf/pipeline_accident_analytics.json`).

- **Trigger:** Daily schedule at 6:00 AM
- **Flow:** `act_ingest` → `act_clean` → `act_load_sql`
- Each activity runs the corresponding Databricks notebook in sequence
- If any notebook fails, the pipeline stops and downstream activities are skipped

To import the pipeline into your own ADF instance, upload `adf/pipeline_accident_analytics.json` via ADF Studio → Author → Import from pipeline template.

---

## Aggregate Tables (Azure SQL Database)

| Table | Rows | Description |
|---|---|---|
| `agg_by_state` | 49 | Total accidents and avg severity per state |
| `agg_by_severity` | 4 | Accident count per severity level |
| `agg_by_time` | 84 | Accidents by year and month |
| `agg_by_weather` | 20 | Top 20 weather conditions and avg severity |
| `agg_by_hour` | 24 | Accidents by hour of day |

---

## Key Findings

- California has the most accidents with 1.74 million — 22% of all US accidents
- 79% of accidents are Severity 2 (moderate impact on traffic)
- Peak accident hours are 7am, 8am, 4pm and 5pm — rush hours
- Fair weather has the most accidents (2.5M) — people drive carelessly in good conditions
- Accidents grew steadily from 2016 to 2022 then dropped in 2023

---

## Power BI Dashboard

- **Page 1** — Accidents by State (bar chart) and Severity Distribution (pie chart)
- **Page 2** — Year Trend (line chart) and Accidents by Hour of Day (bar chart)
- **Page 3** — Weather Conditions (bar chart) and Average Severity by Weather (bar chart)

---

## Pipeline Setup (Manual)

1. Upload `US_Accidents_March23.csv` to ADLS Gen2 `raw` container
2. Run `notebooks/01_ingest_explore.ipynb` to explore data
3. Run `notebooks/02_clean_transform.ipynb` to clean and transform
4. Run `notebooks/03_load_sql.ipynb` to load aggregates to Azure SQL Database
5. Open `powerbi/us_accidents_dashboard.pbix` in Power BI Desktop

Or trigger the full pipeline automatically via Azure Data Factory.

---

## Team

| Member | Role |
|---|---|
| Jainil Malaviya | Ingestion and Infrastructure Lead |
| Rohan | Transformation Lead |
| Jayabal | Serving and Visualization Lead |
