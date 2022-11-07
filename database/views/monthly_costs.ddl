CREATE OR REPLACE VIEW "MONTHLY_COSTS" (
    "DRIVINGMONTH",
    "KWH",
    "KM",
    "PAID",
    "GAS_PAID"
) AS
    SELECT
        drivingmonth,
        SUM(kwh)                              kwh,
        SUM(distance)                         km,
/* + 3% Ladeverluste */
        SUM(kwh +(kwh * 0.03)) * AVG(k.price) paid, 
/* bei 10 Liter verbrauch auf 100km */
        SUM(distance / 10) * AVG(s.price)     gas_paid
    FROM
        drive_history dh,
        sprit         s,
        sprit         k
    WHERE
        drivingday     BETWEEN trunc(k.valid_from) AND trunc(k.valid_to)
        AND drivingday BETWEEN trunc(s.valid_from) AND trunc(s.valid_to)
        AND k.price_type = 'KWH'
        AND s.price_type = 'DIESEL'
    GROUP BY
        drivingmonth;