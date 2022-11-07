CREATE OR REPLACE VIEW "STATUS" (
    "STATUS_DATE",
    "TIME",
    "BATSTATUS12V",
    "BATTERYCHARGE",
    "BATTERYSTATUS",
    "THEORETICALRANGE",
    "DOORLOCK",
    "CLIMATE",
    "FRUNKOPEN",
    "TRUNKOPEN",
    "TIREPRESSURELAMPALL",
    "PLUGIN",
    "REMAINTIME"
)  AS
    SELECT
        status_date,
        time,
        batstatus12v,
        batterycharge,
        batterystatus,
        evmoderange theoreticalrange,
        doorlock,
        climate,
        frunkopen,
        trunkopen,
        tirepressurelampall,
        plugin,
        CASE
            WHEN batterycharge = 'true' THEN
                remaintime
            ELSE
                0
        END         remaintime
    FROM
        eniro e,
        JSON_TABLE ( json_data, '$'
                COLUMNS (
                    time NUMBER PATH '$.time',
                    batstatus12v NUMBER PATH '$.battery.batSoc',
                    tirepressurelampall NUMBER PATH '$.tirePressureLamp.tirePressureLampAll',
                    climate VARCHAR2 PATH '$.airCtrlOn',
                    frunkopen VARCHAR2 PATH '$.hoodOpen',
                    trunkopen VARCHAR2 PATH '$.trunkOpen',
                    doorlock VARCHAR2 PATH '$.doorLock',
                    NESTED PATH '$.evStatus[*]'
                        COLUMNS (
                            batterycharge VARCHAR2 PATH '$.batteryCharge',
                            batterystatus NUMBER PATH '$.batteryStatus',
                            plugin NUMBER PATH '$.batteryPlugin',
                            remaintime NUMBER PATH '$.remainTime2.atc.value',
                            evmoderange NUMBER PATH '$.drvDistance.rangeByFuel.evModeRange.value'
                        )
                )
            )
        jt
    WHERE
        e.json_type = 'STATUS';