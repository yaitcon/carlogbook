create or replace procedure car_remote_control(p_command in varchar2 ) as
  l_clob varchar2(1000);
begin

if p_command not in ('dooropen','doorlock','stopclimate','climate','startcharge','stopcharge','status','odo','loc','monthlyreport','drivehistory') then 
Raise_Application_Error (-20001, 'Invalid Commando'); 
else
 
/* Change hostname here */
l_clob := apex_web_service.make_rest_request(
              p_url => 'https://yourhost/?apiendpoint=' || p_command,
              p_http_method => 'GET');
              
end if;              
end;
/
