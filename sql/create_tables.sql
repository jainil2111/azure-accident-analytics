-- ============================================
-- Azure Accident Analytics
-- DDL Scripts for Azure SQL Database
-- Database: de-project-db
-- Server: deprojectserver2026.database.windows.net
-- ============================================

-- Table 1: Accidents by State
CREATE TABLE agg_by_state (
    State               VARCHAR(2)      NOT NULL,
    total_accidents     BIGINT          NOT NULL,
    avg_severity        DECIMAL(5,2)    NOT NULL,
    PRIMARY KEY (State)
);

-- Table 2: Accidents by Severity
CREATE TABLE agg_by_severity (
    Severity            VARCHAR(1)      NOT NULL,
    total_accidents     BIGINT          NOT NULL,
    PRIMARY KEY (Severity)
);

-- Table 3: Accidents by Year and Month
CREATE TABLE agg_by_time (
    Year                INT             NOT NULL,
    Month               INT             NOT NULL,
    total_accidents     BIGINT          NOT NULL,
    PRIMARY KEY (Year, Month)
);

-- Table 4: Accidents by Weather Condition (Top 20)
CREATE TABLE agg_by_weather (
    Weather_Condition   VARCHAR(100)    NOT NULL,
    total_accidents     BIGINT          NOT NULL,
    avg_severity        DECIMAL(5,2)    NOT NULL,
    PRIMARY KEY (Weather_Condition)
);

-- Table 5: Accidents by Hour of Day
CREATE TABLE agg_by_hour (
    Hour                VARCHAR(2)      NOT NULL,
    total_accidents     BIGINT          NOT NULL,
    PRIMARY KEY (Hour)
);
