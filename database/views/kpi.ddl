--------------------------------------------------------
--  DDL for View KPI
--------------------------------------------------------

  CREATE OR REPLACE VIEW "KPI" ("ORDERNR", "KPI_VAL", "KPI_NAME", "COLOR", "KPI_DEVICE") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  with rawdata as (
select 6 ordernr, max(km) kpi_val, 'Kilometerstand' Kpi_name, 
 case when max(km) >= 14000 then 'redalert' else 'greenok' end color 
  from odo
union all 
select 5 ordernr,  LATEST_batstatus12v_VALUE batstatus12v, 'Ladezustand 12V' ,
case when LATEST_batstatus12v_VALUE < 40 then 'redalert' else 'greenok' end color
from latest_status
union all
select 1 ordernr, LATEST_BATTERYSTATUS_VALUE batterystatus, concat('Ladezustand EV',case when LATEST_BATTERYCHARGE_VALUE = 'true' then ' (Lädt noch ca. ' || to_char(to_date(LATEST_REMAINTIME_VALUE*60,'sssss'),'hh24:mi') || ')' else '' end ) ,
case when LATEST_BATTERYSTATUS_VALUE < 15 then 'redalert' else case when LATEST_BATTERYCHARGE_VALUE = 'true' then 'greenload' else 'greenok' end end color
from latest_status
union all
select 4 ordernr,LATEST_THEORETICALRANGE_VALUE, 'Theo. Reichweite in km',
case when LATEST_BATTERYSTATUS_VALUE < 15 then 'redalert' else 'greenok' end color
from latest_status
union all
select 2 ordernr, LATEST_THEORETICALRANGE_VALUE-case 
  when to_char(status_date,'MM') in (10,11,12,01,02,03)      
  then (LATEST_THEORETICALRANGE_VALUE/100)*10 else 0 end, 
  'Akt. Realrw nach Jahreszeit in km' ,
case when LATEST_BATTERYSTATUS_VALUE < 15 then 'redalert' else 'greenok' end
from latest_status
union all
select 3 ordernr ,LATEST_THEORETICALRANGE_VALUE-(LATEST_THEORETICALRANGE_VALUE/100*30)-
  case when to_char(status_date,'MM') in (10,11,12,01,02,03) 
       then (LATEST_THEORETICALRANGE_VALUE/100*10) else 0 end,  
       'Akt. Realrw nach JZ bei 130km/h in km',
       case when LATEST_BATTERYSTATUS_VALUE < 25 then 'redalert' else 'greenok' end
from latest_status
union all
select 7 ordernr, case when LATEST_BATTERYCHARGE_VALUE = 'true' then 1 else 0 end, 
case when LATEST_BATTERYCHARGE_VALUE = 'true' then 'EV ' || LATEST_BATTERYSTATUS_VALUE || '% (Lädt noch ca.  ' || to_char(to_date(LATEST_REMAINTIME_VALUE*60,'sssss'),'hh24:mi') || ') RW: ' || LATEST_THEORETICALRANGE_VALUE || ' km' else 
'EV %' || LATEST_BATTERYSTATUS_VALUE||' - in KM: '||
TO_CHAR(LATEST_THEORETICALRANGE_VALUE-case 
  when to_char(status_date,'MM') in (10,11,12,01,02,03)      
  then (LATEST_THEORETICALRANGE_VALUE/100)*10 else 0 end)
END,
case when LATEST_BATTERYSTATUS_VALUE < 15 then 'redalert' else case when LATEST_BATTERYCHARGE_VALUE = 'true' then 'greenload' else 'greenok' end end color
from latest_status
union all
select 8 ordernr,case when LATEST_DOORLOCK_VALUE='true' then 1 else 0 end , 'Türen',
case when LATEST_DOORLOCK_VALUE = 'false' then 'redalert' else 'greenok' end color
from latest_status
union all
select 9 ordernr,case when LATEST_CLIMATE_VALUE='true' then 1 else 0 end, concat('Klimaanlage',case when LATEST_CLIMATE_VALUE = 'true' then ' (läuft)' else '' end ),
case when LATEST_CLIMATE_VALUE = 'true' then 'greenload' else 'greenok' end color
from latest_status
)
select "ORDERNR","KPI_VAL","KPI_NAME","COLOR", case when ordernr = 7 then 'MOBILE' else 'WEB' end KPI_DEVICE from rawdata order by ordernr asc
;
