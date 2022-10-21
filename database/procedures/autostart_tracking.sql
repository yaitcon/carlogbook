--------------------------------------------------------
--  DDL for Procedure AUTOSTART_TRACKING
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "TOM"."AUTOSTART_TRACKING" as
begin

 for r in (select latest_status_date from latest_status)
 loop /* enable jobs  falls der letzte refresh schon zulange her ist*/
 if r.latest_status_date < sysdate+1/24 then
    DBMS_SCHEDULER.enable( name => '"TOM"."GET_REPORT"');
    DBMS_SCHEDULER.enable( name => '"TOM"."STATUS_TRACKING"');
 end if;
 end loop;
end;

/
