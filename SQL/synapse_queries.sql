-- =====================================================================
-- Synapse Serverless SQL Scripts
-- Project: Glassdoor Big Data Pipeline on Azure
-- Author:  Waseek Lareef
-- Module:  LDS7005M - Big Data and Cloud Computing
-- Purpose: Create database, views over Gold-layer Delta tables,
--          and run analytical queries.
-- =====================================================================


-- ---------------------------------------------------------------------
-- 1. Create the database (run on the 'master' database)
-- ---------------------------------------------------------------------
CREATE DATABASE GoldDB;
GO


-- ---------------------------------------------------------------------
-- 2. Create views over the Gold-layer Delta tables
--    (Switch the 'Use database' selector to GoldDB before running)
-- ---------------------------------------------------------------------
CREATE VIEW gold_rating_by_year AS
SELECT * FROM OPENROWSET(
    BULK 'https://waseekstr.dfs.core.windows.net/glassdoor-data/gold/rating_by_year/',
    FORMAT = 'DELTA') AS d;
GO

CREATE VIEW gold_dimension_averages AS
SELECT * FROM OPENROWSET(
    BULK 'https://waseekstr.dfs.core.windows.net/glassdoor-data/gold/dimension_averages/',
    FORMAT = 'DELTA') AS d;
GO

CREATE VIEW gold_employment_stats AS
SELECT * FROM OPENROWSET(
    BULK 'https://waseekstr.dfs.core.windows.net/glassdoor-data/gold/employment_stats/',
    FORMAT = 'DELTA') AS d;
GO

CREATE VIEW gold_rating_distribution AS
SELECT * FROM OPENROWSET(
    BULK 'https://waseekstr.dfs.core.windows.net/glassdoor-data/gold/rating_distribution/',
    FORMAT = 'DELTA') AS d;
GO

CREATE VIEW gold_recommend_breakdown AS
SELECT * FROM OPENROWSET(
    BULK 'https://waseekstr.dfs.core.windows.net/glassdoor-data/gold/recommend_breakdown/',
    FORMAT = 'DELTA') AS d;
GO

CREATE VIEW gold_tenure_stats AS
SELECT * FROM OPENROWSET(
    BULK 'https://waseekstr.dfs.core.windows.net/glassdoor-data/gold/tenure_stats/',
    FORMAT = 'DELTA') AS d;
GO


-- ---------------------------------------------------------------------
-- 3. Analytical queries
-- ---------------------------------------------------------------------

-- Query 1: Average overall rating by year
SELECT *
FROM gold_rating_by_year
ORDER BY year;


-- Query 2: Sub-dimension averages grouped by overall rating
SELECT *
FROM gold_dimension_averages
ORDER BY rating DESC;


-- Query 3: Statistics by employment type (current vs former employees)
SELECT *
FROM gold_employment_stats
ORDER BY employment_type;


-- ---------------------------------------------------------------------
-- 4. KQL query for Log Analytics pipeline monitoring
--    Note: run in the Log Analytics workspace, not in Synapse.
-- ---------------------------------------------------------------------
/*
ADFPipelineRun
| where TimeGenerated > ago(1d)
| project TimeGenerated, PipelineName, Status, RunId
| order by TimeGenerated desc
*/
