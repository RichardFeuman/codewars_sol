
select journey_name  journey
       , station_name 
       from
(select 
  journey_id,
  case when 
       row_number() over(partition by journey_name) = 1 then journey_name
       else null end journey_name,
       concat( station_name, ' (' , sequence_number::text, ')') as  station_name
       from
(
  select 
      j.journey_name,
      js.journey_id,
      st.station_name,
      js.sequence_number,
      last_value(st.station_name)
      over(partition by j.journey_name 
          order by js.sequence_number 
          rows between unbounded 
           preceding and unbounded following) as last_station
      
      
from stations st left join 
  journey_stop js on st.id = js.station_id
  left join journey j on j.id = js.journey_id
) paths
  where last_station = 'Hell'
    order by 
    journey_id, sequence_number) as paths_to_hell
