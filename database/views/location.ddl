--------------------------------------------------------
--  DDL for View LOCATION
--------------------------------------------------------

  CREATE OR REPLACE  VIEW "LOCATION" ("STATUS_DATE", "LATITUDE", "LONGITUDE") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  with gpsdata as (
SELECT  STATUS_DATE,LATITUDE,LONGITUDE
FROM eniro e ,
JSON_TABLE (json_data, '$' 
  columns (  
      latitude NUMBER PATH '$.latitude',
      longitude NUMBER PATH '$.longitude'
)) jt
where e.json_type = 'LOCATION')
select "STATUS_DATE","LATITUDE","LONGITUDE" from gpsdata
;
