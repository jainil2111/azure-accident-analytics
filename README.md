# 🚦 Azure Accident Analytics

> End-to-end data engineering pipeline on Microsoft Azure processing 7.7 million US traffic accident records (2016–2023).

## 📊 Dataset
- **Source**: [US Accidents (2016-2023)](https://www.kaggle.com/datasets/sobhanmoosavi/us-accidents/data) — Kaggle
- **Size**: ~3GB, 7,728,394 rows, 46 columns
- **Domain**: US countrywide traffic accidents across 49 states

## 🏗️ Architecture

Raw CSV → Azure Data Lake Storage Gen2 → Azure Databricks (PySpark) → Azure SQL Database → Power BI

## ⚙️ Tech Stack
| Layer | Technology |
|---|---|
| Storage | Azure Data Lake Storage Gen2 |
| Processing | Azure Databricks (Apache Spark 3.4.1) |
| Serving | Azure SQL Database |
| Visualization | Power BI Desktop |
| Version Control | GitHub |

## 📁 Repository Structure

- notebooks/ — Databricks PySpark notebooks
- sql/ — DDL scripts for Azure SQL Database
- powerbi/ — Power BI dashboard (.pbix)
- docs/ — Architecture diagram & report
- data-sample/ — Small sample of dataset (not full 3GB)

## 🔍 Key Findings
- **Top state**: California with 1.74M accidents
- **Most common severity**: Level 2 (79% of all accidents)
- **Date range**: January 2016 – March 2023
- **Biggest data quality issue**: End_Lng column (44% null values)

## 👥 Team
| Member | Role |
|---|---|
| Jainil | Ingestion & Infrastructure Lead |
| Rohan | Transformation Lead |
| Jayabal | Serving & Visualization Lead |

## 🚀 Pipeline Setup
1. Upload raw CSV to ADLS Gen2 `raw` container
2. Run `notebooks/01_ingest_explore.ipynb` to explore data
3. Run `notebooks/02_clean_transform.ipynb` to clean and transform
4. Load aggregates to Azure SQL Database
5. Connect Power BI to SQL Database for visualization
