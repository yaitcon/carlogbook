--------------------------------------------------------
--  DDL for Procedure GET_KIA_CHARGING_STATUS
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "GET_KIA_CHARGING_STATUS" (p_ignore_state in varchar2 default 'N' ) as
  l_clob varchar2(1000);
begin

 for r in (select latest_status_date,latest_batterycharge_value from latest_status)
 loop /* refreshe den status nur wenn geladen wird oder wenn es laut parameter keine rolle spielt, ob geladen wird */
 if r.latest_batterycharge_value = 'true' or p_ignore_state = 'Y' then
  l_clob := to_char(apex_web_service.make_rest_request(
              p_url => 'https://test.glasknochen.at/nodeconnector/?apiendpoint=status',
              p_http_method => 'GET'));
dbms_session.sleep(1);
if r.latest_batterycharge_value = 'false' then  
 l_clob := to_char(apex_web_service.make_rest_request(
              p_url => 'https://test.glasknochen.at/nodeconnector/?apiendpoint=odo',
              p_http_method => 'GET'));
 dbms_session.sleep(1);             
 l_clob := to_char(apex_web_service.make_rest_request(
              p_url => 'https://test.glasknochen.at/nodeconnector/?apiendpoint=loc',
              p_http_method => 'GET'));
end if;
 else 
 dbms_scheduler.enable('STOP_FAST_TRACKING');
 Raise_Application_Error (-20001, 'No Charging active - cancel fast tracking'); 
 end if;
 end loop;
end;

/
