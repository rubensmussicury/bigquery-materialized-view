/*********************************************************************************
 FILE         : scripts-carga-bq.sql
 NAME         : Scripts
 DESCRIPTION  : Scripts de carga para Vídeo-Aula - Materialized Views
 AUTHOR       : Rubens Mussi Cury
 DATE         : 12-05-2020
=================================================================================
 CHANGE HISTORY
=================================================================================
PR  DATE        AUTHOR         DESCRIPTION 
--  ----------  -------------  --------------------------------------------------

*********************************************************************************/


# ==============================================================================================
# Antes de utilizar estes scripts, é necessário criar o ambiente em seu GCP.
#
# Para isso, você pode criar seus Datasets e Tabelas utilizando o arquivo 
# [view-streaming.ipynb]
#
# Não se esqueça também de substituir neste arquivo o [nome-projeto] pelo
# nome do seu projeto criado no GCP.
# ==============================================================================================



# Gera os 144 milhões de voos iniciais na tabela AIRLINE_FLIGHTS.
CREATE OR REPLACE TABLE `[nome-projeto].primary_dataset.AIRLINE_FLIGHTS` AS 
SELECT
  YEAR,
  MONTH,
  HOUR,
  AIRLINE,
  CAST(RAND() * (YEAR - 1000) AS INT64) AS FLIGHTS
FROM
  UNNEST(GENERATE_ARRAY(1, 5000)),
  UNNEST(GENERATE_ARRAY(2010, 2019, 1)) AS YEAR,
  UNNEST(GENERATE_ARRAY(1, 12, 1)) AS MONTH,
  UNNEST(GENERATE_ARRAY(1, 24, 1)) AS HOUR,
  UNNEST(["Southwest Airlines Co.: WN", "American Airlines Inc.: AA", "Delta Air Lines Inc.: DL", "SkyWest Airlines Inc.: OO", "United Air Lines Inc.: UA", "American Eagle Airlines Inc.: MQ", "US Airways Inc.: US", "Northwest Airlines Inc.: NW", "ExpressJet Airlines Inc.: XE", "ExpressJet Airlines Inc.: EV"]) AS AIRLINE;



# Gera as 114.804.000 milhões de vendas na tabela COMPANY_SALES
CREATE OR REPLACE TABLE `[nome-projeto].secondary_dataset.COMPANY_SALES` AS 
SELECT
  DATE,
  COMPANY,
  ROUND(RAND() * (YEAR - 1000), 2) AS SALES
FROM
  UNNEST(GENERATE_ARRAY(1, 5000)),
  UNNEST(GENERATE_DATE_ARRAY("2010-01-01", CURRENT_DATE(), INTERVAL 1 DAY)) AS DATE,
  UNNEST(["Progressive Sports", "Country Parts Shop", "Bikes and Motorbikes", "Budget Toy Store", "Advanced Bike Components", "Bicycle Warehouse Inc."]) AS COMPANY