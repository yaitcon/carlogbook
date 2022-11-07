CREATE OR REPLACE VIEW "CHARGING_DETAILS" (
    "CHARGENR",
    "STATUS_DATE",
    "CHARGING_DAY",
    "APPROX_STARTED",
    "APPROX_REMAINTIME",
    "MINBATPERCENTAGE",
    "MAXBATPERCENTAGE",
    "PERCENTAGE_LOADED",
    "CHARGING_TYPE",
    "APPROX_DURATION",
    "LRUN_DATE",
    "PLUGIN",
    "PREV_BATTERYSTATUS"
) AS
    WITH basis AS (
        SELECT
            status.*,
            nvl(LAG(batterystatus)
                OVER(
                ORDER BY
                    status_date ASC
                ), batterystatus) prev_batterystatus,
            nvl(LAG(batterycharge)
                OVER(
                ORDER BY
                    status_date ASC
                ), batterycharge) prev_batterycharge,
            nvl(LAG(status_date)
                OVER(
                ORDER BY
                    status_date ASC
                ), status_date)   prev_status_date
        FROM
            status
    ), charges AS (
        SELECT
            mno                                                               chargenr,
            status_date,
            trunc(least(prev_status_date, frun_date))                         charging_day,
            prev_status_date                                                  approx_started,
            remaintime_first                                                  approx_remaintime,
            least(prev_batterystatus, batterystatus_first)                     minbatpercentage,
            batterystatus_last                                                 maxbatpercentage,
            batterystatus_last - least(prev_batterystatus, batterystatus_first) percentage_loaded,
            CASE
                WHEN plugin = 1
                     OR LAG(plugin)
                        OVER(PARTITION BY mno
                             ORDER BY
                                 status_date ASC
                ) = 1 THEN
                    'DC'
                WHEN plugin = 2
                     OR LAG(plugin)
                        OVER(PARTITION BY mno
                             ORDER BY
                                 status_date ASC
                ) = 2 THEN
                    'AC'
                ELSE
                    'AC'
            END                                                               charging_type,
            lrun_date - least(prev_status_date, frun_date)                    approx_duration,
            lrun_date,
            plugin,
            prev_batterystatus
        FROM
            basis MATCH_RECOGNIZE (
                ORDER BY status_date
                MEASURES
                    match_number() AS mno,
                    FIRST(remaintime) AS remaintime_first,
                    FIRST(batterystatus) AS batterystatus_first,
                    LAST(batterystatus) AS batterystatus_last,
                    FIRST(status_date) AS frun_date,
                    LAST(status_date) AS lrun_date
                ALL ROWS PER MATCH
            PATTERN ( charge + ) DEFINE
                charge AS ( ( batterystatus > prev(batterystatus) )
                            OR batterycharge = 'true'
                            OR prev_batterycharge = 'true' )
            )
    )
    SELECT
        "CHARGENR",
        "STATUS_DATE",
        "CHARGING_DAY",
        "APPROX_STARTED",
        "APPROX_REMAINTIME",
        "MINBATPERCENTAGE",
        "MAXBATPERCENTAGE",
        "PERCENTAGE_LOADED",
        "CHARGING_TYPE",
        "APPROX_DURATION",
        "LRUN_DATE",
        "PLUGIN",
        "PREV_BATTERYSTATUS"
    FROM
        charges;