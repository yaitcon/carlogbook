--------------------------------------------------------
--  DDL for View MONTHLY_REPORT
--------------------------------------------------------

  CREATE OR REPLACE VIEW "MONTHLY_REPORT" ("STATUS_DATE", "START_MONTH", "STARTED", "ENDED", "DISTANCE", "DURATION_DRIVE", "DURATION_IDLE", "FIRST_STATUS") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  with rowdata as (
SELECT  status_date,trunc(to_datE(started,'YYYYMMDD'),'MM') start_month,
        to_datE(started,'YYYYMMDD') started,to_date(ended,'YYYYMMDD') ended,distance,duration_drive,duration_idle
FROM eniro e ,
JSON_TABLE (json_data, '$' 
  columns (  
      started NUMBER PATH '$.start',
      ended PATH '$.end',
    NESTED PATH '$.driving[*]'
        COLUMNS (
            distance NUMBER PATH '$.distance',
            NESTED PATH '$.durations[*]'
            columns ( duration_drive NUMBER PATH '$.drive',
                      duration_idle number path '$.idle')
        )                          
)) jt
where e.json_type = 'MONHTLYREPORT' ),
getfirst as (
select e.STATUS_DATE,e.START_MONTH,e."STARTED",
       e."ENDED",e."DISTANCE",e."DURATION_DRIVE",e."DURATION_IDLE",
       first_value(e.STATUS_DATE) over (partition by START_MONTH order by status_date asc) first_status
from rowdata e)
select "STATUS_DATE","START_MONTH","STARTED","ENDED","DISTANCE","DURATION_DRIVE","DURATION_IDLE","FIRST_STATUS" 
from getfirst where status_date = first_status
;
