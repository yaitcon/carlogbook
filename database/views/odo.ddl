CREATE OR REPLACE VIEW "ODO" (
    "STATUS_DATE",
    "KM"
) AS
    WITH rawdata AS (
        SELECT
            status_date,
            km
        FROM
            eniro e,
            JSON_TABLE ( json_data, '$'
                    COLUMNS (
                        km NUMBER PATH '$.value'
                    )
                )
            jt
        WHERE
            e.json_type = 'ODO'
    )
    SELECT
        trunc(status_date) status_date,
        MAX(km)            km
    FROM
        rawdata
    GROUP BY
        trunc(status_date);