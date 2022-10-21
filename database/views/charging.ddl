--------------------------------------------------------
--  DDL for View CHARGING
--------------------------------------------------------

  CREATE OR REPLACE VIEW "TOM"."CHARGING" ("CHARGING_DAY", "APPROX_STARTED", "APPROX_REMAINTIME", "MINBATPERCENTAGE", "MAXBATPERCENTRAGE", "PERCENTAGE_LOADED", "APPROX_KWH_LOADED", "CHARGING_TYPE", "APPROX_DURATION", "CHARGENR") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  select min(STATUS_DATE)       charging_day,
       max(status_Date)       approx_started,
       max(approx_remaintime) approx_remaintime,
       min(minbatpercentage)  minbatpercentage, 
       max(maxbatpercentage)  MAXBATPERCENTRAGE,
       max(percentage_loaded) percentage_loaded,
      64/100* max(percentage_loaded) approx_kwh_loaded,
       max(charging_type)     charging_type,
       max(approx_duration)   approx_duration,
       chargenr 
from CHARGING_DETAILS 
group by chargenr
;
