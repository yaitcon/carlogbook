
  CREATE OR REPLACE VIEW "CHARGING" 
                    ("CHARGING_DAY", "APPROX_STARTED", 
                     "APPROX_REMAINTIME", "MINBATPERCENTAGE", 
                     "MAXBATPERCENTRAGE", "PERCENTAGE_LOADED", 
                     "APPROX_KWH_LOADED", "CHARGING_TYPE", 
                     "APPROX_DURATION", "CHARGENR") AS 
  select min(STATUS_DATE)       charging_day,
         min(approx_started)       approx_started,
         max(approx_remaintime) approx_remaintime,
         min(minbatpercentage)  minbatpercentage, 
         max(maxbatpercentage)  MAXBATPERCENTRAGE,
         max(maxbatpercentage) -    min(minbatpercentage)  percentage_loaded,
         max(param_value)/100* ( max(maxbatpercentage) -    min(minbatpercentage))  approx_kwh_loaded,
         max(charging_type)     charging_type,
         max(approx_duration)   approx_duration,
         chargenr 
from CHARGING_DETAILS , params 
where params.param_name = 'BATTERY_NETTO_KWH'
group by chargenr;

