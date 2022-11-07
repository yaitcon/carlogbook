create or replace procedure get_car_report as
begin

car_remote_control('drivehistory');
dbms_session.sleep(30);

car_remote_control('monthlyreport');
dbms_session.sleep(30);
              
end;
/
