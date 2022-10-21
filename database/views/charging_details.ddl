--------------------------------------------------------
--  DDL for View CHARGING_DETAILS
--------------------------------------------------------

  CREATE OR REPLACE VIEW "TOM"."CHARGING_DETAILS" ("CHARGENR", "STATUS_DATE", "CHARGING_DAY", "APPROX_STARTED", "APPROX_REMAINTIME", "MINBATPERCENTAGE", "MAXBATPERCENTAGE", "PERCENTAGE_LOADED", "CHARGING_TYPE", "APPROX_DURATION") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  with charges as (
select mno chargenr,STATUS_DATE,
 trunc(frun_date) charging_day,frun_date approx_started,
       remaintime_first approx_remaintime,batterytatus_first minbatpercentage,
       batterytatus_last maxbatpercentage,batterytatus_last-batterytatus_first percentage_loaded,
       case when plugin = 1 or lag(plugin) over (order by status_date asc) = 1
     then 'DC' 
     when plugin = 2 or lag(plugin) over (order by status_date asc) = 2
     then 'AC'
     else 'AC' end charging_type,
       lrun_date-frun_date approx_duration
     from status
match_recognize (
 -- partition by plugin
  order by STATUS_DATE
  measures
    match_number() as mno,
    first(remaintime) as remaintime_first,
    first(batterystatus) as batterytatus_first,
    last(batterystatus) as batterytatus_last,
    first(status_date) as frun_date,
    last(status_date) as lrun_date
  all rows per match
  pattern ( charge+ ) 
  define 
--    charge as (prev_plugin > 0 or plugin > 0) or (plugin > 0 and next_plugin = 0)
   charge as (batterycharge = 'true')
))
select "CHARGENR","STATUS_DATE","CHARGING_DAY","APPROX_STARTED","APPROX_REMAINTIME","MINBATPERCENTAGE","MAXBATPERCENTAGE","PERCENTAGE_LOADED","CHARGING_TYPE","APPROX_DURATION" from charges
;
