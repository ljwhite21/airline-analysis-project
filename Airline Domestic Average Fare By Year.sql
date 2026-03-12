SELECT Year,
  ROUND(AVG(`Average Market Fare _Current __`), 2) AS avg_fare_by_year
FROM `aff-average-air-fare-carrier.Air_Fare_Trends.AFF_carrier_data` 
Group By Year
ORDER BY Year