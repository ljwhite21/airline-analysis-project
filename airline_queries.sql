=======================================================================
-- U.S. Airline Fare Market Analysis
-- Author: Levi White
-- Dataset: Bureau of Transporation Statistics
=======================================================================

  
=======================================================================
-- Query 1
-- Average airline fare by year
=======================================================================
  
SELECT Year,
  ROUND(AVG(`Average Market Fare _Current __`), 2) AS avg_fare_by_year
FROM `aff-average-air-fare-carrier.Air_Fare_Trends.AFF_carrier_data` 
Group By Year
ORDER BY Year;

=======================================================================
-- Query 2
-- Highest average fares by airline
=======================================================================
  
WITH no_of_flights AS (
  SELECT 
    CARRIER_NAME,
    COUNT(CARRIER_NAME) AS total_flights,
    ROUND(AVG(`Average Market Fare _Current __`), 2) AS avg_fare
  FROM `aff-average-air-fare-carrier.Air_Fare_Trends.AFF_carrier_data` 
  GROUP BY CARRIER_NAME
)
SELECT 
  total_flights,
  CARRIER_NAME,
  avg_fare
FROM no_of_flights n
WHERE n.total_flights > 29
ORDER BY avg_fare DESC;

=======================================================================
-- Query 3
-- Passenger volume by airline
=======================================================================
