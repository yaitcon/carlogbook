CREATE OR REPLACE VIEW "LOCATION_HISTORY" 
  ("MOVINGNR", "FIRST_STATUS_DATE", "LAST_STATUS_DATE", "FIRST_LATITUDE", "FIRST_LONGITUDE", "LAST_LATITUDE", "LAST_LONGITUDE", "DISTANCE", "LINEBETWEEN", "START_POINT", "END_POINT")  AS 
  with movings as (select distinct 
      mno movingnr,
      fstatus_date first_status_date,
      first_value(lstatus_date) over (partition by mno order by status_date desc) last_status_date,
      first_value(p_latitude) over (partition by mno order by status_date asc) first_latitude,
      first_value(p_longitude) over (partition by mno order by status_date asc) first_longitude,
      first_value(latitude) over (partition by mno order by status_date desc) last_latitude ,
      first_value(longitude) over (partition by mno order by status_date desc) last_longitude 
from location
match_recognize (
  order by STATUS_DATE
  measures
    match_number() as mno,
    first(status_date) as fstatus_date,
    last(status_date) as lstatus_date,
    prev(latitude) as p_latitude,
    prev(longitude) as p_longitude
  all rows per match
  pattern ( moving+ ) 
  define 
   moving as( latitude != prev(latitude))
)), distance_calc as (
select m.*,
 sdo_geom.sdo_distance(
         sdo_geometry(2001, 4326, sdo_point_type(first_longitude, first_latitude, null), null, null),
         sdo_geometry(2001, 4326, sdo_point_type(last_longitude,last_latitude, null), null, null),
         0.005,
         'unit=km'
       ) distance,
       sdo_geometry (2002,
                     4326,
                     NULL,
                     sdo_elem_info_array (1,
                                          2,
                                          1),
                     sdo_ordinate_array (sdo_point_type(first_longitude, first_latitude, null).x,
                                         sdo_point_type(first_longitude, first_latitude, null).y,
                                         sdo_point_type(last_longitude, last_latitude, null).x,
                                         sdo_point_type(last_longitude, last_latitude, null).y)) linebetween,
        SDO_GEOMETRY(2001, 4326, MDSYS.SDO_POINT_TYPE(first_longitude, first_latitude, NULL), NULL, NULL) start_point,
        SDO_GEOMETRY(2001, 4326, MDSYS.SDO_POINT_TYPE(last_longitude,last_latitude, NULL), NULL, NULL) end_point
from movings m where (first_latitude <> last_latitude and first_longitude <> last_longitude)
)
select "MOVINGNR","FIRST_STATUS_DATE","LAST_STATUS_DATE",
       "FIRST_LATITUDE","FIRST_LONGITUDE","LAST_LATITUDE",
       "LAST_LONGITUDE","DISTANCE","LINEBETWEEN","START_POINT","END_POINT"
from distance_calc where distance < 500;

