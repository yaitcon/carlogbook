--------------------------------------------------------
--  DDL for Procedure DRIVING_FORECAST
-- funktioniert erst wenn genug daten in der drivehistory existieren ( ab 150 oder so)
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE"DRIVING_FORECAST" as 

    v_setlst DBMS_DATA_MINING.SETTING_LIST;
BEGIN


    v_setlst(DBMS_DATA_MINING.ALGO_NAME) := DBMS_DATA_MINING.ALGO_EXPONENTIAL_SMOOTHING;
    v_setlst(DBMS_DATA_MINING.EXSM_INTERVAL) := DBMS_DATA_MINING.EXSM_INTERVAL_DAY;
    v_setlst(DBMS_DATA_MINING.EXSM_PREDICTION_STEP) := '30';
    v_setlst(DBMS_DATA_MINING.EXSM_MODEL) := DBMS_DATA_MINING.EXSM_HW;
    v_setlst(DBMS_DATA_MINING.EXSM_SEASONALITY) := '12';

    DBMS_DATA_MINING.DROP_MODEL( model_name => 'ROI_FORECAST');

    DBMS_DATA_MINING.CREATE_MODEL2(
        model_name => 'ROI_FORECAST',
        mining_function => 'TIME_SERIES',
        data_query => 'SELECT trunc(status_date) status_date,sum(kwh) kwh FROM drive_history group by trunc(status_date)',
        set_list => v_setlst,
        case_id_column_name => 'status_date',
        target_column_name => 'kwh'
    );
    --select * from dm$p0roi_forecast;

END;

/
