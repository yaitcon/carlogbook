--------------------------------------------------------
--  DDL for View LATEST_LOCATION
--------------------------------------------------------

  CREATE OR REPLACE VIEW "LATEST_LOCATION" ("STATUS_DATE", "LATITUDE", "LONGITUDE") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  with lateststatus as 
(select max(status_date) maxstatus from location) ,
rawdata as (
select status_date,latitude,longitude
from location, lateststatus
where status_date = maxstatus)
select "STATUS_DATE","LATITUDE","LONGITUDE" from rawdata
;
