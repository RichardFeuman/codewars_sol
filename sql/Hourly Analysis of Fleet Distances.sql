
-- Substitute with your SQL


with ranges as (
        select ts from generate_series(
            date_trunc('hour', (SELECT MIN(time) 
                                FROM cars 
                                WHERE EXTRACT(HOUR FROM time) BETWEEN 8 AND 18)),
            date_trunc('hour', (SELECT MAX(time) 
                                FROM cars 
                                WHERE EXTRACT(HOUR FROM time) BETWEEN 8 AND 18)),
            '1 hour'::interval
        ) AS gs(ts)
  ), start_end as (
    
    select ts as start,
           coalesce(lead(ts) over(), max(ts) over() + interval '1 hour') as end,
           row_number() over() as rn
    from ranges
  
  )
select distinct to_char(se.start, 'YYYY-MM-DD HH24:MI:SS') time_from,
       to_char(se.end, 'YYYY-MM-DD HH24:MI:SS')  time_to,
       sum(km) over(partition by se.start, se.end) as km,
       concat('Total of ',se.rn::varchar, ' hour(s): ', 
              round(sum(km) over(order by se.start, se.end), 1)::varchar) as total_km
from start_end se
left join cars on time between se.start and se.end
and date_trunc('hour', time) = date_trunc('hour', se.start)
order by time_from
limit 10
