CREATE OR REPLACE VIEW "LATEST_STATUS" (
    "STATUS_DATE",
    "LATEST_STATUS_DATE",
    "LATEST_REMAINTIME_VALUE",
    "LATEST_BATSTATUS12V_VALUE",
    "LATEST_BATTERYCHARGE_VALUE",
    "LATEST_BATTERYSTATUS_VALUE",
    "LATEST_THEORETICALRANGE_VALUE",
    "LATEST_DOORLOCK_VALUE",
    "LATEST_CLIMATE_VALUE",
    "LATEST_FRUNKOPEN_VALUE",
    "LATEST_TRUNKOPEN_VALUE",
    "LATEST_TIREPRESSURELAMPALL_VALUE",
    "LATEST_PLUGIN_VALUE"
) AS
    WITH latest_doorlock AS (
        SELECT DISTINCT
            FIRST_VALUE(status_date)
            OVER(
                ORDER BY
                    status_date DESC
            ) doorlock_status_date,
            FIRST_VALUE(json_type)
            OVER(
                ORDER BY
                    status_date DESC
            ) doorlock_type
        FROM
            eniro
        WHERE
            json_type IN ( 'DOOROPEN', 'DOORLOCK' )
            AND json_data LIKE '% successful%'
    ), latest_climate AS (
        SELECT DISTINCT
            FIRST_VALUE(status_date)
            OVER(
                ORDER BY
                    status_date DESC
            ) climate_status_date,
            FIRST_VALUE(json_type)
            OVER(
                ORDER BY
                    status_date DESC
            ) climate_type
        FROM
            eniro
        WHERE
            json_type IN ( 'CLIMATE', 'STOPCLIMATE' )
            AND json_data LIKE '%"resCode":"0000"%'
    ), latest_charge AS (
        SELECT DISTINCT
            FIRST_VALUE(status_date)
            OVER(
                ORDER BY
                    status_date DESC
            ) charge_status_date,
            FIRST_VALUE(json_type)
            OVER(
                ORDER BY
                    status_date DESC
            ) charge_type
        FROM
            eniro
        WHERE
            json_type IN ( 'STOPCHARGE', 'STARTCHARGE' )
            AND json_data LIKE '% successful%'
    ), latest_status AS (
        SELECT
            status_date,
            FIRST_VALUE(status_date)
            OVER(
                ORDER BY
                    status_date DESC
            ) latest_status_date,
            FIRST_VALUE(remaintime)
            OVER(
                ORDER BY
                    status_date DESC
            ) latest_remaintime_value,
            FIRST_VALUE(batstatus12v)
            OVER(
                ORDER BY
                    status_date DESC
            ) latest_batstatus12v_value,
            FIRST_VALUE(batterycharge)
            OVER(
                ORDER BY
                    status_date DESC
            ) latest_batterycharge_value,
            FIRST_VALUE(batterystatus)
            OVER(
                ORDER BY
                    status_date DESC
            ) latest_batterystatus_value,
            FIRST_VALUE(theoreticalrange)
            OVER(
                ORDER BY
                    status_date DESC
            ) latest_theoreticalrange_value,
            FIRST_VALUE(doorlock)
            OVER(
                ORDER BY
                    status_date DESC
            ) latest_doorlock_value,
            FIRST_VALUE(climate)
            OVER(
                ORDER BY
                    status_date DESC
            ) latest_climate_value,
            FIRST_VALUE(frunkopen)
            OVER(
                ORDER BY
                    status_date DESC
            ) latest_frunkopen_value,
            FIRST_VALUE(trunkopen)
            OVER(
                ORDER BY
                    status_date DESC
            ) latest_trunkopen_value,
            FIRST_VALUE(tirepressurelampall)
            OVER(
                ORDER BY
                    status_date DESC
            ) latest_tirepressurelampall_value,
            FIRST_VALUE(plugin)
            OVER(
                ORDER BY
                    status_date DESC
            ) latest_plugin_value
        FROM
            status
    )
    SELECT
        "STATUS_DATE",
        "LATEST_STATUS_DATE",
        "LATEST_REMAINTIME_VALUE",
        "LATEST_BATSTATUS12V_VALUE",
        CASE
            WHEN latest_status_date > charge_status_date THEN
                "LATEST_BATTERYCHARGE_VALUE"
            ELSE
                decode(charge_type, 'STARTCHARGE', 'true', 'false')
        END "LATEST_BATTERYCHARGE_VALUE",
        "LATEST_BATTERYSTATUS_VALUE",
        "LATEST_THEORETICALRANGE_VALUE",
        CASE
            WHEN latest_status_date > doorlock_status_date THEN
                "LATEST_DOORLOCK_VALUE"
            ELSE
                decode(climate_type, 'DOOROPEN', 'true', 'false')
        END "LATEST_DOORLOCK_VALUE",
        CASE
            WHEN latest_status_date > climate_status_date THEN
                "LATEST_CLIMATE_VALUE"
            ELSE
                decode(climate_type, 'CLIMATE', 'true', 'false')
        END "LATEST_CLIMATE_VALUE",
        "LATEST_FRUNKOPEN_VALUE",
        "LATEST_TRUNKOPEN_VALUE",
        "LATEST_TIREPRESSURELAMPALL_VALUE",
        "LATEST_PLUGIN_VALUE"
    FROM
        latest_status,
        latest_climate,
        latest_doorlock,
        latest_charge
    WHERE
        status_date = latest_status_date;