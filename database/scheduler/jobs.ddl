BEGIN
    DBMS_SCHEDULER.CREATE_JOB (
            job_name => '"AUTOSTART_JOB"',
            job_type => 'PLSQL_BLOCK',
            job_action => 'begin AUTOSTART_TRACKING; end;',
            number_of_arguments => 0,
            start_date => TO_TIMESTAMP_TZ('2022-10-10 21:33:13.703110000 EUROPE/BERLIN','YYYY-MM-DD HH24:MI:SS.FF TZR'),
            repeat_interval => 'FREQ=HOURLY;INTERVAL=1',
            end_date => NULL,
            enabled => FALSE,
            auto_drop => FALSE,
            comments => 'Falls mal tracking deaktiviert wurde');

    DBMS_SCHEDULER.SET_ATTRIBUTE( 
             name => '"AUTOSTART_JOB"', 
             attribute => 'store_output', value => TRUE);
    DBMS_SCHEDULER.SET_ATTRIBUTE( 
             name => '"AUTOSTART_JOB"', 
             attribute => 'logging_level', value => DBMS_SCHEDULER.LOGGING_OFF);
      
    DBMS_SCHEDULER.enable(
             name => '"AUTOSTART_JOB"');
END;
/

BEGIN
    DBMS_SCHEDULER.CREATE_JOB (
            job_name => '"CHARGE_TRACKING"',
            job_type => 'PLSQL_BLOCK',
            job_action => 'begin get_kia_charging_status; end;',
            number_of_arguments => 0,
            start_date => TO_TIMESTAMP_TZ('2022-10-20 14:48:00.000000000 EUROPE/BERLIN','YYYY-MM-DD HH24:MI:SS.FF TZR'),
            repeat_interval => 'FREQ=MINUTELY;INTERVAL=5',
            end_date => NULL,
            enabled => FALSE,
            auto_drop => FALSE,
            comments => 'Call over nginx and node kia_http_get_status.js');
 
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
            job_action => 'begin get_kia_report; end;',
            number_of_arguments => 0,
            start_date => TO_TIMESTAMP_TZ('2022-10-11 17:43:03.000000000 EUROPE/BERLIN','YYYY-MM-DD HH24:MI:SS.FF TZR'),
            repeat_interval => 'FREQ=DAILY;BYHOUR=6,8;BYMINUTE=12;BYSECOND=0',
            end_date => NULL,
            enabled => FALSE,
            auto_drop => FALSE,
            comments => 'Call over nginx and node kia_report.js');

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
            job_name => '"STATUS_TRACKING"',
            job_type => 'PLSQL_BLOCK',
            job_action => 'begin get_kia_charging_status(''Y''); end;',
            number_of_arguments => 0,
            start_date => TO_TIMESTAMP_TZ('2022-10-11 17:41:03.000000000 EUROPE/BERLIN','YYYY-MM-DD HH24:MI:SS.FF TZR'),
            repeat_interval => 'FREQ=MINUTELY;BYHOUR=7,8,9,10,11,12,13,14,15,16,17,18,19,20,21;BYMINUTE=0,30;BYSECOND=30',
            end_date => NULL,
            enabled => FALSE,
            auto_drop => FALSE,
            comments => 'Call over nginx and node kia_http_get_status.js');

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
            comments => 'bei bedarf');

 
    DBMS_SCHEDULER.SET_ATTRIBUTE( 
             name => '"STOP_FAST_TRACKING"', 
             attribute => 'store_output', value => TRUE);
    DBMS_SCHEDULER.SET_ATTRIBUTE( 
             name => '"STOP_FAST_TRACKING"', 
             attribute => 'logging_level', value => DBMS_SCHEDULER.LOGGING_OFF);
      
   
  
    
END;
/

-- verhindere parallelläufe: --

BEGIN
  DBMS_SCHEDULER.create_incompatibility(
    incompatibility_name => 'JOBS_DO_NOT_RUN_SAME_TIME', 
    object_name          => 'CHARGE_TRACKING,GET_REPORT,STATUS_TRACKING',
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


