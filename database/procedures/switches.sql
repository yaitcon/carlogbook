create or replace procedure switch_charging is  
lbv varchar2(30);
lpv varchar2(30);
BEGIN

car_remote_control('status');
dbms_session.sleep(30);

select latest_batterycharge_value,latest_plugin_value
into lbv,lpv
from latest_status
;

if lbv = 'false' and lpv > 0 then 
car_remote_control('startcharge');
else 
car_remote_control('stopcharge');
end if;
dbms_session.sleep(10);
END;
/

create or replace procedure switch_climate is  
lcv varchar2(30);
BEGIN

car_remote_control('status');
dbms_session.sleep(30);

select latest_climate_value
into lcv
from latest_status
;

if lcv = 'false' then 
car_remote_control('climate');
else 
car_remote_control('stopclimate');
end if;
dbms_session.sleep(10);
END;
/

create or replace procedure switch_door is  
ldv varchar2(30);
BEGIN

car_remote_control('status');
dbms_session.sleep(30);

select latest_doorlock_value
into ldv
from latest_status
;

if ldv = 'true' then 
car_remote_control('dooropen');
else 
/* close door */
car_remote_control('doorlock');
end if;
dbms_session.sleep(10);
END;
/

create or replace procedure switch_fast_tracking is  
runsornot varchar2(30);
BEGIN

select enabled
into runsornot
from user_scheduler_jobs 
where job_name = 'CHARGE_TRACKING' 
;

if runsornot = 'FALSE' then 
/* disable periodical jobs */              
DBMS_SCHEDULER.disable( name => '"GET_REPORT"');
DBMS_SCHEDULER.disable( name => '"STATUS_TRACKING"');
DBMS_SCHEDULER.set_attribute_null( name => '"CHARGE_TRACKING"', attribute => 'max_runs');
DBMS_SCHEDULER.set_attribute( name => '"CHARGE_TRACKING"', attribute => 'start_date', value => TO_TIMESTAMP_TZ(to_char(trunc(sysdate,'MI') + INTERVAL '2' SECOND,'YYYY-MM-DD HH24:MI:SS') || ' EUROPE/BERLIN','YYYY-MM-DD HH24:MI:SS TZR'));
DBMS_SCHEDULER.set_attribute( name => '"CHARGE_TRACKING"', attribute => 'max_runs' , value => 20);
DBMS_SCHEDULER.enable( name => '"CHARGE_TRACKING"');

else 
/* enable periodical jobs */

DBMS_SCHEDULER.disable( name => '"CHARGE_TRACKING"');
DBMS_SCHEDULER.enable( name => '"GET_REPORT"');
DBMS_SCHEDULER.enable( name => '"STATUS_TRACKING"');

end if;

END;
/