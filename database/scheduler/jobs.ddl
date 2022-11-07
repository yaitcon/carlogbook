BEGIN
    DBMS_SCHEDULER.CREATE_JOB (
            job_name => '"STATUS_TRACKING"',
            job_type => 'PLSQL_BLOCK',
            job_action => 'begin get_car_infos; end;',
            number_of_arguments => 0,
            start_date => TO_TIMESTAMP_TZ('2022-10-11 17:41:03.000000000 EUROPE/BERLIN','YYYY-MM-DD HH24:MI:SS.FF TZR'),
            repeat_interval => 'FREQ=MINUTELY;BYHOUR=7,8,9,10,11,12,13,14,15,16,17,18,19,20,21;BYMINUTE=0,30;BYSECOND=30',
            end_date => NULL,
            enabled => FALSE,
            auto_drop => FALSE,
            comments => 'Call over nginx and node carcommunicaton.js');

         
     
 
    DBMS_SCHEDULER.SET_ATTRIBUTE( 
             name => '"STATUS_TRACKING"', 
             attribute => 'store_output', value => TRUE);
    DBMS_SCHEDULER.SET_ATTRIBUTE( 
             name => '"STATUS_TRACKING"', 
             attribute => 'logging_level', value => DBMS_SCHEDULER.LOGGING_OFF);
      
   
  
    
    DBMS_SCHEDULER.enable(
             name => '"STATUS_TRACKING"');
END;
/
BEGIN
    DBMS_SCHEDULER.CREATE_JOB (
            job_name => '"STOP_FAST_TRACKING"',
            job_type => 'PLSQL_BLOCK',
            job_action => 'begin

begin
  DBMS_SCHEDULER.stop_job( job_name => ''"CHARGE_TRACKING"'',force=>true);
exception when others then null;
end;

  DBMS_SCHEDULER.disable( name => ''"CHARGE_TRACKING"'');
  DBMS_SCHEDULER.enable( name => ''"GET_REPORT"'');
  DBMS_SCHEDULER.enable( name => ''"STATUS_TRACKING"'');
end;
',
            number_of_arguments => 0,
            start_date => NULL,
            repeat_interval => NULL,
            end_date => NULL,
            enabled => FALSE,
            auto_drop => FALSE,
            comments => 'stopped fast tracking - if car is full or plugged out or not on DC Charger');    
 
    DBMS_SCHEDULER.SET_ATTRIBUTE( 
             name => '"STOP_FAST_TRACKING"', 
             attribute => 'store_output', value => TRUE);
    DBMS_SCHEDULER.SET_ATTRIBUTE( 
             name => '"STOP_FAST_TRACKING"', 
             attribute => 'logging_level', value => DBMS_SCHEDULER.LOGGING_OFF);
    
END;
/

BEGIN
    DBMS_SCHEDULER.CREATE_JOB (
            job_name => '"CHARGE_TRACKING"',
            job_type => 'PLSQL_BLOCK',
            job_action => 'begin get_dc_charging_status; end;',
            number_of_arguments => 0,
            start_date => TO_TIMESTAMP_TZ('2022-11-05 21:45:02.000000000 EUROPE/BERLIN','YYYY-MM-DD HH24:MI:SS.FF TZR'),
            repeat_interval => 'FREQ=MINUTELY;INTERVAL=5',
            end_date => NULL,
            enabled => FALSE,
            auto_drop => FALSE,
            comments => 'Call over nginx and node.js carcommunication.js');

         
    DBMS_SCHEDULER.SET_ATTRIBUTE( 
             name => '"CHARGE_TRACKING"', 
             attribute => 'store_output', value => TRUE);
    DBMS_SCHEDULER.SET_ATTRIBUTE( 
             name => '"CHARGE_TRACKING"', 
             attribute => 'logging_level', value => DBMS_SCHEDULER.LOGGING_OFF);
         
  
    DBMS_SCHEDULER.SET_ATTRIBUTE( 
             name => '"CHARGE_TRACKING"', 
             attribute => 'max_runs', value => 20);
    
END;
/

BEGIN
    DBMS_SCHEDULER.CREATE_JOB (
            job_name => '"GET_REPORT"',
            job_type => 'PLSQL_BLOCK',
            job_action => 'begin get_car_report; end;',
            number_of_arguments => 0,
            start_date => TO_TIMESTAMP_TZ('2022-10-11 17:43:03.000000000 EUROPE/BERLIN','YYYY-MM-DD HH24:MI:SS.FF TZR'),
            repeat_interval => 'FREQ=DAILY;BYHOUR=6,8;BYMINUTE=12;BYSECOND=0',
            end_date => NULL,
            enabled => FALSE,
            auto_drop => FALSE,
            comments => 'Call over nginx and node carcommunication.js');

         
     
 
    DBMS_SCHEDULER.SET_ATTRIBUTE( 
             name => '"GET_REPORT"', 
             attribute => 'store_output', value => TRUE);
    DBMS_SCHEDULER.SET_ATTRIBUTE( 
             name => '"GET_REPORT"', 
             attribute => 'logging_level', value => DBMS_SCHEDULER.LOGGING_OFF);
      
   
  
    
    DBMS_SCHEDULER.enable(
             name => '"GET_REPORT"');
END;
/

BEGIN
    DBMS_SCHEDULER.CREATE_JOB (
            job_name => '"JOB_SWITCH_CHARGING"',
            job_type => 'PLSQL_BLOCK',
            job_action => 'begin switch_charging; end;',
            number_of_arguments => 0,
            start_date => NULL,
            repeat_interval => NULL,
            end_date => NULL,
            enabled => FALSE,
            auto_drop => FALSE,
            comments => 'enable or disable plugged car charging');

    DBMS_SCHEDULER.SET_ATTRIBUTE( 
             name => '"JOB_SWITCH_CHARGING"', 
             attribute => 'store_output', value => TRUE);
    DBMS_SCHEDULER.SET_ATTRIBUTE( 
             name => '"JOB_SWITCH_CHARGING"', 
             attribute => 'logging_level', value => DBMS_SCHEDULER.LOGGING_OFF); 
    
END;
/

BEGIN
    DBMS_SCHEDULER.CREATE_JOB (
            job_name => '"JOB_SWITCH_CLIMATE"',
            job_type => 'PLSQL_BLOCK',
            job_action => 'begin switch_climate; end;',
            number_of_arguments => 0,
            start_date => NULL,
            repeat_interval => NULL,
            end_date => NULL,
            enabled => FALSE,
            auto_drop => FALSE,
            comments => 'enable or disable climate in car');

    DBMS_SCHEDULER.SET_ATTRIBUTE( 
             name => '"JOB_SWITCH_CLIMATE"', 
             attribute => 'store_output', value => TRUE);
    DBMS_SCHEDULER.SET_ATTRIBUTE( 
             name => '"JOB_SWITCH_CLIMATE"', 
             attribute => 'logging_level', value => DBMS_SCHEDULER.LOGGING_OFF);
      
END;
/

BEGIN
    DBMS_SCHEDULER.CREATE_JOB (
            job_name => '"JOB_SWITCH_DOOR"',
            job_type => 'PLSQL_BLOCK',
            job_action => 'begin switch_door; end;',
            number_of_arguments => 0,
            start_date => NULL,
            repeat_interval => NULL,
            end_date => NULL,
            enabled => FALSE,
            auto_drop => FALSE,
            comments => 'lock or unlock doors');

    DBMS_SCHEDULER.SET_ATTRIBUTE( 
             name => '"JOB_SWITCH_DOOR"', 
             attribute => 'store_output', value => TRUE);
    DBMS_SCHEDULER.SET_ATTRIBUTE( 
             name => '"JOB_SWITCH_DOOR"', 
             attribute => 'logging_level', value => DBMS_SCHEDULER.LOGGING_OFF);   
END;
/
-- verhindere parallelläufe: --

BEGIN
  DBMS_SCHEDULER.create_incompatibility(
    incompatibility_name => 'JOBS_DO_NOT_RUN_SAME_TIME', 
    object_name          => 'CHARGE_TRACKING,GET_REPORT,STATUS_TRACKING,JOB_SWITCH_DOOR,JOB_SWITCH_CLIMATE,JOB_SWITCH_CHARGING',
    constraint_level     => 'JOB_LEVEL', -- Default
    enabled              => true);
END;
/

SELECT incompatibility_name,
       constraint_level,
       enabled,
       jobs_running_count
FROM   user_scheduler_incompats
ORDER BY 1;


SELECT incompatibility_owner,
       incompatibility_name,
       object_owner,
       object_name
FROM   user_scheduler_incompat_member
ORDER BY 1,2,3,4;


