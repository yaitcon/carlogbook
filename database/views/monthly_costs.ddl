--------------------------------------------------------
--  DDL for View MONTHLY_COSTS
--------------------------------------------------------

  CREATE OR REPLACE VIEW "MONTHLY_COSTS" ("DRIVINGMONTH", "KWH", "KM", "PAID", "GAS_PAID") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  select 
drivingmonth, 
sum(kwh) kwh, 
sum(distance) km,
/* + 3% Ladeverluste */
sum(kwh+(kwh*0.03)) * avg(k.price) PAID, 
/* bei 10 Liter verbrauch auf 100km */
sum(distance/10) * avg( s.price) GAS_PAID  
from drive_history dh, sprit s, sprit k
where drivingday between trunc(k.valid_from) and trunc(k.valid_to)
and drivingday between trunc(s.valid_from) and trunc(s.valid_to)
and k.price_type = 'KWH'
and s.price_type = 'DIESEL'
group by drivingmonth
;
