--------------------------------------------------------
--  DDL for View STATUS
--------------------------------------------------------

  CREATE OR REPLACE  VIEW "STATUS" ("STATUS_DATE", "TIME", "BATSTATUS12V", "BATTERYCHARGE", "BATTERYSTATUS", "THEORETICALRANGE", "DOORLOCK", "CLIMATE", "FRUNKOPEN", "TRUNKOPEN", "TIREPRESSURELAMPALL", "PLUGIN", "REMAINTIME") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  SELECT  status_date, time, batstatus12v , batterycharge, batterystatus,evModeRange theoreticalRange,doorlock,
           climate,frunkopen,trunkOpen,tirePressureLampAll,plugin,case when batterycharge = 'true' then remaintime else 0 end remaintime
FROM eniro e ,
JSON_TABLE (json_data, '$' 
  columns (  
      time NUMBER PATH '$.time',
      batstatus12v NUMBER PATH '$.battery.batSoc',
      tirePressureLampAll NUMBER PATH '$.tirePressureLamp.tirePressureLampAll',
      climate varchar2 PATH '$.airCtrlOn',
      frunkopen varchar2 PATH '$.hoodOpen',
      trunkOpen varchar2 PATH '$.trunkOpen',
      doorlock varchar2 PATH '$.doorLock',
     NESTED PATH '$.evStatus[*]'
            columns ( batterycharge varchar2 PATH '$.batteryCharge',
                      batterystatus NUMBER PATH '$.batteryStatus',
                      plugin NUMBER PATH '$.batteryPlugin',
                      remaintime NUMBER PATH '$.remainTime2.atc.value',
                       evModeRange NUMBER PATH  '$.drvDistance.rangeByFuel.evModeRange.value'
                      )
        )                          
) jt
where e.json_type = 'STATUS'
;
