--------------------------------------------------------
--  DDL for View MONEY_SAVED_FORECAST
--------------------------------------------------------
--easy forcast with sql - -

  CREATE OR REPLACE VIEW "MONEY_SAVED_FORECAST" ("MTH", "MTH_FORCAST", "MONEY_SAVED", "FORECAST")  AS 
  with MONEY_SAVED_MONTH as (
  select
    TRUNC(DRIVINGMONTH,'MM') MTH,
    sum(GAS_PAID-PAID) MONEY_SAVED
  from
    MONTHLY_COSTS A
  group by
    TRUNC(DRIVINGMONTH,'MM')
),MONEY_SAVED_SLOPE as (
  select
    MTH,
    MONEY_SAVED,
    regr_slope(
      MONEY_SAVED,
      extract(year from MTH) * 12 + extract(month from MTH)
    ) over(
      order by
        MTH
      range between
        interval '12' month
      preceding and current row
    ) SLOPE
  from
    MONEY_SAVED_MONTH
) select
  MTH,
  ADD_MONTHS(MTH,12) MTH_FORCAST,
  MONEY_SAVED,
  GREATEST(
    ROUND(MONEY_SAVED + 12 * SLOPE),
    0
  ) FORECAST
from
  MONEY_SAVED_SLOPE
order by MTH
;
