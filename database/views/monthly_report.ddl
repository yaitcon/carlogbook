CREATE OR REPLACE VIEW "MONTHLY_REPORT" 
         ("STATUS_DATE", "START_MONTH", "STARTED", 
          "ENDED", "DISTANCE", "DURATION_DRIVE", 
          "DURATION_IDLE", "FIRST_STATUS") AS 
WITH rowdata AS (
    SELECT
        status_date,
        trunc(to_date(started, 'YYYYMMDD'), 'MM') start_month,
        to_date(started, 'YYYYMMDD')              started,
        to_date(ended, 'YYYYMMDD')                ended,
        distance,
        duration_drive,
        duration_idle
    FROM
        eniro e,
        JSON_TABLE ( json_data, '$'
                COLUMNS (
                    started NUMBER PATH '$.start',
                    ended PATH '$.end',
                    NESTED PATH '$.driving[*]'
                        COLUMNS (
                            distance NUMBER PATH '$.distance',
                            NESTED PATH '$.durations[*]'
                                COLUMNS (
                                    duration_drive NUMBER PATH '$.drive',
                                    duration_idle NUMBER PATH '$.idle'
                                )
                        )
                )
            )
        jt
    WHERE
        e.json_type = 'MONTHLYREPORT'
), getfirst AS (
    SELECT
        e.status_date,
        e.start_month,
        e."STARTED",
        e."ENDED",
        e."DISTANCE",
        e."DURATION_DRIVE",
        e."DURATION_IDLE",
        FIRST_VALUE(e.status_date)
        OVER(PARTITION BY start_month
             ORDER BY
                 status_date ASC
        ) first_status
    FROM
        rowdata e
)
SELECT
    "STATUS_DATE",
    "START_MONTH",
    "STARTED",
    "ENDED",
    "DISTANCE",
    "DURATION_DRIVE",
    "DURATION_IDLE",
    "FIRST_STATUS"
FROM
    getfirst
WHERE
    status_date = first_status;
