create or replace procedure get_dc_charging_status(p_fast_tracking in varchar2 default 'N' ) as
begin

car_remote_control('status');
dbms_session.sleep(30);
  
 for r in (select latest_status_date,latest_batterycharge_value,latest_plugin_value from latest_status)
 loop /* beende den job wenn nicht mehr geladen wird oder nur AC geladen wird */
 if r.latest_batterycharge_value = 'false' or r.latest_plugin_value = 2  then
 dbms_scheduler.enable('STOP_FAST_TRACKING');
 Raise_Application_Error (-20001, 'No DC Charging active - cancel fast tracking'); 
 end if;
 end loop;
 
end;
/