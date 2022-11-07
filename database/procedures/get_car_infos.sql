get_car_infos.sql
create or replace PROCEDURE "GET_CAR_INFOS"  as
begin

car_remote_control('status');
dbms_session.sleep(30);
car_remote_control('odo');
dbms_session.sleep(30);
car_remote_control('loc');
dbms_session.sleep(30);

end;
/