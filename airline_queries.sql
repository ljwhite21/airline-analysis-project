=======================================================================
-- U.S. Airline Fare Market Analysis
-- Author: Levi White
-- Dataset: Bureau of Transporation Statistics
=======================================================================

  
=======================================================================
-- Query 1
-- Average airline fare by year
=======================================================================
  
  WITH over_30_yrs AS (
  SELECT CARRIER_NAME
  FROM `airline-data-490803.Airline_Data.Airline Carrier Data Table`
  GROUP BY CARRIER_NAME  
  HAVING COUNT(*) >= 30
)

SELECT 
  ROUND(AVG(`Average Market Fare _Current __`), 2) AS avg_fare,
  SUM(`Market Passengers`) AS pass_total,
  Year
FROM `airline-data-490803.Airline_Data.Airline Carrier Data Table` a
JOIN over_30_yrs o
  ON a.CARRIER_NAME = o.CARRIER_NAME
GROUP BY year
ORDER BY year

=======================================================================
-- Query 2
-- Highest average fares by airline
=======================================================================
  
WITH no_of_flights AS (
  SELECT 
    CARRIER_NAME,
    COUNT(CARRIER_NAME) AS total_flights,
    ROUND(AVG(`Average Market Fare _Current __`), 2) AS avg_fare
  FROM `airline-data-490803.Airline_Data.Airline Carrier Data Table`
  GROUP BY CARRIER_NAME
  HAVING COUNT(CARRIER_NAME) >= 30
)

SELECT 
  CARRIER_NAME,
  avg_fare
FROM no_of_flights
ORDER BY avg_fare DESC;

=======================================================================
-- Query 3
-- Highest passenger volume by airline
=======================================================================

SELECT  
  CARRIER_NAME,
  SUM(`Market Passengers`) total_passengers,
  COUNT(CARRIER_NAME)
FROM `airline-data-490803.Airline_Data.Airline Carrier Data Table` 
GROUP BY CARRIER_NAME
HAVING COUNT(*) >= 30
ORDER BY total_passengers DESC;

=======================================================================
-- Query 4
-- Which airlines generate the most revenue per mile?
=======================================================================
  
SELECT 
  CARRIER_NAME,
  SUM(`Market Revenue _Current __`) AS total_revenue,
  SUM(`Market Passenger Miles Flown _sm_`) AS total_miles,
  SUM(`Market Revenue _Current __`) / SUM(`Market Passenger Miles Flown _sm_`) AS true_yield
FROM `airline-data-490803.Airline_Data.Airline Carrier Data Table` 
GROUP BY CARRIER_NAME
HAVING COUNT(*) >= 30
ORDER BY true_yield;

=======================================================================
-- Query 5
-- Is there a relationship between fare prices and passenger volume?
=======================================================================
## Aggregated airline, fare and passenger data for initial comparison
  
SELECT 
  CARRIER_NAME,
  ROUND(AVG(`Average Market Fare _Current __`), 2) AS avg_fare,
  SUM(`Market Passengers`) AS total_passengers
FROM `airline-data-490803.Airline_Data.Airline Carrier Data Table` 
GROUP BY CARRIER_NAME
HAVING COUNT(*) >= 30
ORDER BY total_passengers DESC;

## Check Correlation of air fare to passenger totals across all airlines
  
SELECT 
  CORR(`Average Market Fare _Current __`, `Market Passengers`)
FROM `airline-data-490803.Airline_Data.Airline Carrier Data Table`;

## Check correlation of air fare to passenger totals by airline

SELECT
  CARRIER_NAME,
  CORR(`Average Market Fare _Current __`, `Market Passengers`) AS Airfare_Passenger_Corr
FROM `airline-data-490803.Airline_Data.Airline Carrier Data Table`
GROUP BY CARRIER_NAME
HAVING COUNT(*) >= 30
ORDER BY Airfare_Passenger_Corr;

## Check correlation between fare category and average passengers by airline

SELECT
  CARRIER_NAME,
  CASE
    WHEN `Average Market Fare _Current __` < 100 THEN 'Low'
    WHEN `Average Market Fare _Current __` < 200 THEN 'Medium'
    ELSE 'High'
  END AS fare_category,
  ROUND(AVG(`Market Passengers`), 2) AS avg_passengers
FROM `airline-data-490803.Airline_Data.Airline Carrier Data Table` 
WHERE CARRIER_NAME IN (
  SELECT CARRIER_NAME
  FROM `airline-data-490803.Airline_Data.Airline Carrier Data Table`
  GROUP BY CARRIER_NAME
  HAVING COUNT(*) >= 30
)
GROUP BY fare_category, CARRIER_NAME;

=======================================================================
-- Query 6
-- Which airlines show the most stable pricing over time?
=======================================================================
## Calculate Standard Deviation to compare price volatility alongside average airline cost. 
  
SELECT
  CARRIER_NAME,
  ROUND(STDDEV(`Average Market Fare _Current __`), 4) AS fare_volatility,
  ROUND(AVG(`Average Market Fare _Current __`), 2) AS avg_fare,
  COUNT(*) AS observations
FROM `airline-data-490803.Airline_Data.Airline Carrier Data Table` 
GROUP BY CARRIER_NAME
HAVING COUNT(*) >= 30
ORDER BY fare_volatility ASC;
