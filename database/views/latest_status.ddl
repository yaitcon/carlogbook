--------------------------------------------------------
--  DDL for View LATEST_STATUS
--------------------------------------------------------

  CREATE OR REPLACE VIEW "LATEST_STATUS" ("STATUS_DATE", "LATEST_STATUS_DATE", "LATEST_REMAINTIME_VALUE", "LATEST_BATSTATUS12V_VALUE", "LATEST_BATTERYCHARGE_VALUE", "LATEST_BATTERYSTATUS_VALUE", "LATEST_THEORETICALRANGE_VALUE", "LATEST_DOORLOCK_VALUE", "LATEST_CLIMATE_VALUE", "LATEST_FRUNKOPEN_VALUE", "LATEST_TRUNKOPEN_VALUE", "LATEST_TIREPRESSURELAMPALL_VALUE", "LATEST_PLUGIN_VALUE") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  with latest_status as 
(select status_date, first_value(status_date) over (order by status_date desc) latest_status_date,
first_value(remaintime) over (order by status_date desc) latest_remaintime_value, 
first_value(batstatus12v) over (order by status_date desc) latest_batstatus12v_value, 
first_value(batterycharge) over (order by status_date desc) latest_batterycharge_value, 
first_value(batterystatus) over (order by status_date desc) latest_batterystatus_value, 
first_value(THEORETICALRANGE) over (order by status_date desc) latest_THEORETICALRANGE_value, 
first_value(DOORLOCK) over (order by status_date desc) latest_DOORLOCK_value, 
first_value(CLIMATE) over (order by status_date desc) latest_CLIMATE_value, 
first_value(FRUNKOPEN) over (order by status_date desc) latest_FRUNKOPEN_value, 
first_value(TRUNKOPEN) over (order by status_date desc) latest_TRUNKOPEN_value, 
first_value(TIREPRESSURELAMPALL) over (order by status_date desc) latest_TIREPRESSURELAMPALL_value, 
first_value(PLUGIN) over (order by status_date desc) latest_PLUGIN_value
from status)
select "STATUS_DATE","LATEST_STATUS_DATE","LATEST_REMAINTIME_VALUE","LATEST_BATSTATUS12V_VALUE","LATEST_BATTERYCHARGE_VALUE","LATEST_BATTERYSTATUS_VALUE","LATEST_THEORETICALRANGE_VALUE","LATEST_DOORLOCK_VALUE","LATEST_CLIMATE_VALUE","LATEST_FRUNKOPEN_VALUE","LATEST_TRUNKOPEN_VALUE","LATEST_TIREPRESSURELAMPALL_VALUE","LATEST_PLUGIN_VALUE" from latest_status
where status_date = latest_status_date
;
