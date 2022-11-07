CREATE OR REPLACE FORCE EDITIONABLE VIEW "LATEST_LOCATION" (
    "STATUS_DATE",
    "LATITUDE",
    "LONGITUDE",
    "GEO_POINT"
)  AS
    WITH lateststatus AS (
        SELECT
            MAX(status_date) maxstatus
        FROM
            location
    ), rawdata AS (
        SELECT
            status_date,
            latitude,
            longitude,
            geo_point
        FROM
            location,
            lateststatus
        WHERE
            status_date = maxstatus
    )
    SELECT
        "STATUS_DATE",
        "LATITUDE",
        "LONGITUDE",
        geo_point
    FROM
        rawdata;