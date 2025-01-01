-- Substitute with your SQL

with reach_threshold as (
select   id 
       , date
       , amount
       , limit_day
       , limit_day - ( select min(date) from transactions ) days_to_reach_threshold
       , min(limit_day - ( select min(date) from transactions )) over() as first_threshold_flag
       from
(
select 
      a.id,
      a.date,
      a.amount,
      case when 
        sum(a.amount) over(order by date ) >=15 then
        a.date else null end as limit_day
from transactions a ) as cum
  )
select  id 
       , date
       , amount
       , days_to_reach_threshold
from reach_threshold 
where days_to_reach_threshold = first_threshold_flag 
  or  days_to_reach_threshold is null
