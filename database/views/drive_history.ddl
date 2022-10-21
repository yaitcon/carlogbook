--------------------------------------------------------
--  DDL for View DRIVE_HISTORY
--------------------------------------------------------

  CREATE OR REPLACE VIEW "DRIVE_HISTORY" ("STATUS_DATE", "DRIVINGYEAR", "DRIVINGMONTH", "DRIVINGWEEK", "DRIVINGDAY", "DISTANCE", "KWH", "KWH_PRO_100KM", "REGENERATED_KWH") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  with rawdata as (
SELECT status_date,
       trunc(to_date(datetime,'YYYYMMDD'),'YYYY') drivingyear,
       trunc(to_date(datetime,'YYYYMMDD'),'MM') drivingmonth,
       trunc(to_date(datetime,'YYYYMMDD'),'IW') drivingweek, 
       to_date(datetime,'YYYYMMDD') drivingday, 
       distance, 
       total/1000 kwh, 
       round((total/1000/distance)*100,2) kwh_pro_100km,
       round(regeneration/1000,2) regenerated_kwh
FROM eniro e ,
JSON_TABLE (json_data, '$' 
  columns (  
    NESTED PATH '$.history[*]'
        COLUMNS (
            DateTime NUMBER PATH '$.rawDate',
            distance NUMBER PATH '$.distance',
            regeneration NUMBER PATH '$.regen',
            NESTED PATH '$.consumption[*]'
            columns (     total NUMBER PATH '$.total')
        )                          
)) jt
where e.json_type = 'DRIVEHISTORY'),
lsd as (select max(status_date) maxstatus, 
                                  drivingday 
                             from rawdata
                             group by  drivingday)
select r."STATUS_DATE",r."DRIVINGYEAR",r."DRIVINGMONTH",r."DRIVINGWEEK",r."DRIVINGDAY",r."DISTANCE",r."KWH",r."KWH_PRO_100KM",r."REGENERATED_KWH" from rawdata r,lsd
where r.status_date = lsd.maxstatus
and r.drivingday = lsd.drivingday
;
