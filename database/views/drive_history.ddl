CREATE OR REPLACE VIEW "DRIVE_HISTORY" (
    "STATUS_DATE",
    "DRIVINGYEAR",
    "DRIVINGMONTH",
    "DRIVINGWEEK",
    "DRIVINGDAY",
    "DISTANCE",
    "ENGINE_KWH",
    "KWH",
    "KWH_PRO_100KM",
    "REGENERATED_KWH"
)  AS
    WITH rawdata AS (
        SELECT
            status_date,
            trunc(to_date(datetime, 'YYYYMMDD'), 'YYYY')    drivingyear,
            trunc(to_date(datetime, 'YYYYMMDD'), 'MM')      drivingmonth,
            trunc(to_date(datetime, 'YYYYMMDD'), 'IW')      drivingweek,
            to_date(datetime, 'YYYYMMDD')                   drivingday,
            distance,
            engine / 1000                                   engine_kwh,
            total / 1000                                    kwh,
            round((total / 1000 / distance) * 100, 2)       kwh_pro_100km,
            round(regeneration / 1000, 2)                   regenerated_kwh
        FROM
            eniro e,
            JSON_TABLE ( json_data, '$'
                    COLUMNS (
                        NESTED PATH '$.history[*]'
                            COLUMNS (
                                datetime NUMBER PATH '$.rawDate',
                                distance NUMBER PATH '$.distance',
                                regeneration NUMBER PATH '$.regen',
                                NESTED PATH '$.consumption[*]'
                                    COLUMNS (
                                        total NUMBER PATH '$.total',
                                        engine NUMBER PATH '$.engine'
                                    )
                            )
                    )
                )
            jt
        WHERE
            e.json_type = 'DRIVEHISTORY'
    ), lsd AS (
        SELECT
            MAX(status_date) maxstatus,
            drivingday
        FROM
            rawdata
        GROUP BY
            drivingday
    )
    SELECT
        r."STATUS_DATE",
        r."DRIVINGYEAR",
        r."DRIVINGMONTH",
        r."DRIVINGWEEK",
        r."DRIVINGDAY",
        r."DISTANCE",
        r."ENGINE_KWH",
        r."KWH",
        r."KWH_PRO_100KM",
        r."REGENERATED_KWH"
    FROM
        rawdata r,
        lsd
    WHERE
            r.status_date = lsd.maxstatus
        AND r.drivingday = lsd.drivingday;