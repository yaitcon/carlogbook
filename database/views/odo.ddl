--------------------------------------------------------
--  DDL for View ODO
--------------------------------------------------------

  CREATE OR REPLACE VIEW "ODO" ("STATUS_DATE", "KM") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  with rawdata as (
SELECT  STATUS_DATE,KM
FROM eniro e ,
JSON_TABLE (json_data, '$' 
  columns (  
      km NUMBER PATH '$.value'
)) jt
where e.json_type = 'ODO')
select trunc(status_date) status_date,max(km) km from rawdata
group by trunc(status_date)
;
