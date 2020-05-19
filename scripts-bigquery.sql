/*********************************************************************************
 FILE         : scripts-bigquery.sql
 NAME         : Scripts
 DESCRIPTION  : Scripts Adicionais na Vídeo-Aula - Materialized Views
 AUTHOR       : Rubens Mussi Cury
 DATE         : 12-05-2020
=================================================================================
 CHANGE HISTORY
=================================================================================
PR  DATE        AUTHOR         DESCRIPTION 
--  ----------  -------------  --------------------------------------------------

*********************************************************************************/


# ==============================================================================================
# Scripts utilizados na tabela [AIRLINE_FLIGHTS]
# ==============================================================================================

# Exemplo de SQL utilizado no vídeo.
SELECT 
  HOUR,
  SUM(FLIGHTS),
  AVG(FLIGHTS)
FROM
  `[nome-projeto].primary_dataset.AIRLINE_FLIGHTS`
GROUP BY
  HOUR
ORDER BY
  HOUR


# Exemplo de uma View Convencional.
CREATE VIEW IF NOT EXISTS `[nome-projeto].primary_dataset.VW_AIRLINE_FLIGHTS_YEARLY_DAY_TIME`
AS
SELECT
  YEAR,
  CASE 
    WHEN HOUR >= 1 AND HOUR <= 6  THEN "(01-06) DAWN"
    WHEN HOUR >= 7 AND HOUR <= 11  THEN "(07-11) MORNING"
    WHEN HOUR >= 12 AND HOUR <= 17  THEN "(12-17) AFTERNOON"
    ELSE "(18- 24) EVENING" 
  END AS DAY_TIME,
  SUM(FLIGHTS) AS TOTAL_FLIGHTS
FROM
  `[nome-projeto].primary_dataset.AIRLINE_FLIGHTS`
GROUP BY
  YEAR,
  DAY_TIME
ORDER BY
  YEAR,
  DAY_TIME


# Exemplo de uma View Materializada.
CREATE MATERIALIZED VIEW `[nome-projeto].secondary_dataset.MVW_AIRLINE_FLIGHTS_YEARLY_DAY_TIME`
AS
SELECT
  YEAR,
  CASE 
    WHEN HOUR >= 1 AND HOUR <= 6  THEN "(01-06) DAWN"
    WHEN HOUR >= 7 AND HOUR <= 11  THEN "(07-11) MORNING"
    WHEN HOUR >= 12 AND HOUR <= 17  THEN "(12-17) AFTERNOON"
    ELSE "(18- 24) EVENING" 
  END AS DAY_TIME,
  SUM(FLIGHTS) AS TOTAL_FLIGHTS
FROM
  `[nome-projeto].secondary_dataset.AIRLINE_FLIGHTS`
GROUP BY
  YEAR,
  DAY_TIME


# ==============================================================================================
# Scripts utilizados na tabela [COMPANY_SALES]
# ==============================================================================================

# Exemplo de View
# Não usar o ROUND() no TOTAL_QUARTER senão impede a geração da MVIEW.
CREATE OR REPLACE VIEW `[nome-projeto].secondary_dataset.VW_COMPANY_SALES_QUARTERLY`
AS
SELECT
  EXTRACT(YEAR FROM DATE) AS YEAR,
  CASE
    WHEN EXTRACT(MONTH FROM DATE) IN (1, 2, 3) THEN "Q1"
    WHEN EXTRACT(MONTH FROM DATE) IN (4, 5, 6) THEN "Q2"
    WHEN EXTRACT(MONTH FROM DATE) IN (7, 8, 9) THEN "Q3"
    ELSE "Q4" 
  END AS QUARTER,
  COMPANY,
  SUM(SALES) AS TOTAL_QUARTER
FROM
  `[nome-projeto].primary_dataset.COMPANY_SALES`
GROUP BY
  YEAR,
  QUARTER,
  COMPANY

# Exemplo de View Materializada
CREATE MATERIALIZED VIEW `[nome-projeto].secondary_dataset.MVW_COMPANY_SALES_QUARTERLY`
AS
SELECT
  EXTRACT(YEAR FROM DATE) AS YEAR,
  CASE
    WHEN EXTRACT(MONTH FROM DATE) IN (1, 2, 3) THEN "Q1"
    WHEN EXTRACT(MONTH FROM DATE) IN (4, 5, 6) THEN "Q2"
    WHEN EXTRACT(MONTH FROM DATE) IN (7, 8, 9) THEN "Q3"
    ELSE "Q4" 
  END AS QUARTER,
  COMPANY,
  SUM(SALES) AS TOTAL_SALES
FROM
  `[nome-projeto].primary_dataset.COMPANY_SALES`
GROUP BY 
  YEAR, 
  QUARTER, 
  COMPANY