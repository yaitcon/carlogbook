CREATE OR REPLACE VIEW "LOCATION" (
    "STATUS_DATE",
    "LATITUDE",
    "LONGITUDE",
    "GEO_POINT"
) AS
    WITH gpsdata AS (
        SELECT
            status_date,
            latitude,
            longitude
        FROM
            eniro e,
            JSON_TABLE ( json_data, '$'
                    COLUMNS (
                        latitude NUMBER PATH '$.latitude',
                        longitude NUMBER PATH '$.longitude'
                    )
                )
            jt
        WHERE
            e.json_type IN ( 'LOC', 'LOCATION' )
    )
    SELECT
        "STATUS_DATE",
        "LATITUDE",
        "LONGITUDE",
        sdo_geometry(2001, 4326, mdsys.sdo_point_type(longitude, latitude, NULL), NULL, NULL) geo_point
    FROM
        gpsdata;