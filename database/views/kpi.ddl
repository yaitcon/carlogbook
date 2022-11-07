CREATE OR REPLACE VIEW "KPI" (
    "ORDERNR",
    "KPI_VAL",
    "KPI_NAME",
    "COLOR",
    "KPI_DEVICE"
)  AS
    WITH rawdata AS (
        SELECT
            6                ordernr,
            MAX(km)          kpi_val,
            'Kilometerstand' kpi_name,
            CASE
                WHEN MAX(km) >= 14000 THEN
                    'redalert'
                ELSE
                    'greenok'
            END              color
        FROM
            odo
        UNION ALL
        SELECT
            5                         ordernr,
            latest_batstatus12v_value batstatus12v,
            'Ladezustand 12V',
            CASE
                WHEN latest_batstatus12v_value < 40 THEN
                    'redalert'
                ELSE
                    'greenok'
            END                       color
        FROM
            latest_status
        UNION ALL
        SELECT
            1                          ordernr,
            latest_batterystatus_value batterystatus,
            concat('Ladezustand EV',
                   CASE
                       WHEN latest_batterycharge_value = 'true' THEN
                           ' (Lädt noch ca. '
                           || to_char(to_date(least(latest_remaintime_value, 1440) * 60 - 1, 'sssss'), 'hh24:mi')
                           || ')'
                       ELSE
                           ''
                   END
            ),
            CASE
                WHEN latest_batterystatus_value < 15 THEN
                    'redalert'
                ELSE
                    CASE
                        WHEN latest_batterycharge_value = 'true' THEN
                                'greenload'
                        ELSE
                            'greenok'
                    END
            END                        color
        FROM
            latest_status
        UNION ALL
        SELECT
            4   ordernr,
            latest_theoreticalrange_value,
            'Theo. Reichweite in km',
            CASE
                WHEN latest_batterystatus_value < 15 THEN
                    'redalert'
                ELSE
                    'greenok'
            END color
        FROM
            latest_status
        UNION ALL
        SELECT
            2 ordernr,
            latest_theoreticalrange_value -
            CASE
                WHEN to_char(status_date, 'MM') IN ( 10, 11, 12, 01,
                                                     02, 03 ) THEN
                        ( latest_theoreticalrange_value / 100 ) * 10
                ELSE
                    0
            END,
            'Akt. Realrw nach Jahreszeit in km',
            CASE
                WHEN latest_batterystatus_value < 15 THEN
                    'redalert'
                ELSE
                    'greenok'
            END
        FROM
            latest_status
        UNION ALL
        SELECT
            3 ordernr,
            latest_theoreticalrange_value - ( latest_theoreticalrange_value / 100 * 30 ) -
            CASE
                WHEN to_char(status_date, 'MM') IN ( 10, 11, 12, 01,
                                                     02, 03 ) THEN
                        ( latest_theoreticalrange_value / 100 * 10 )
                ELSE
                    0
            END,
            'Akt. Realrw nach JZ bei 130km/h in km',
            CASE
                WHEN latest_batterystatus_value < 25 THEN
                    'redalert'
                ELSE
                    'greenok'
            END
        FROM
            latest_status
        UNION ALL
        SELECT
            7   ordernr,
            CASE
                WHEN latest_batterycharge_value = 'true' THEN
                    1
                ELSE
                    0
            END,
            CASE
                WHEN latest_batterycharge_value = 'true' THEN
                    'EV '
                    || latest_batterystatus_value
                    || '% (Lädt noch ca.  '
                    || to_char(to_date(least(latest_remaintime_value, 1440) * 60 - 1, 'sssss'), 'hh24:mi')
                    || ') RW: '
                    || latest_theoreticalrange_value
                    || ' km'
                ELSE
                    'EV %'
                    || latest_batterystatus_value
                    || ' - in KM: '
                    || to_char(latest_theoreticalrange_value -
                               CASE
                                   WHEN to_char(status_date, 'MM') IN(10, 11, 12, 01,
                                                                      02, 03) THEN
                                       (latest_theoreticalrange_value / 100) * 10
                                   ELSE
                                       0
                               END
                    )
            END,
            CASE
                WHEN latest_batterystatus_value < 15 THEN
                    'redalert'
                ELSE
                    CASE
                        WHEN latest_batterycharge_value = 'true' THEN
                                'greenload'
                        ELSE
                            'greenok'
                    END
            END color
        FROM
            latest_status
        UNION ALL
        SELECT
            8   ordernr,
            CASE
                WHEN latest_doorlock_value = 'true' THEN
                    1
                ELSE
                    0
            END,
            'Türen',
            CASE
                WHEN latest_doorlock_value = 'false' THEN
                    'redalert'
                ELSE
                    'greenok'
            END color
        FROM
            latest_status
        UNION ALL
        SELECT
            9   ordernr,
            CASE
                WHEN latest_climate_value = 'true' THEN
                    1
                ELSE
                    0
            END,
            concat('Klimaanlage',
                   CASE
                       WHEN latest_climate_value = 'true' THEN
                           ' (läuft)'
                       ELSE
                           ''
                   END
            ),
            CASE
                WHEN latest_climate_value = 'true' THEN
                    'greenload'
                ELSE
                    'greenok'
            END color
        FROM
            latest_status
    )
    SELECT
        "ORDERNR",
        "KPI_VAL",
        "KPI_NAME",
        "COLOR",
        CASE
            WHEN ordernr = 7 THEN
                'MOBILE'
            ELSE
                'WEB'
        END kpi_device
    FROM
        rawdata
    WHERE
        ordernr NOT IN ( 3, 4, 8, 9 )
    ORDER BY
        ordernr ASC;