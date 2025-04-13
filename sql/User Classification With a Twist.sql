
-- Substitute with your SQL


with x as
(
select 
      user_id,
      count(distinct class) as distinct_class_count
from users
group by 1
), b as (
select 'b' as class, 
         count(distinct user_id) 
         filter(where x.distinct_class_count = 2 or class = 'b') as count
from users join x using(user_id)        
group by 1
), a as (
select class, 
         count(distinct user_id) 
         filter(where x.distinct_class_count = 1) as count
from users join x using(user_id)        
where class = 'a'
group by class
), u as (
select a.*
from a 
union all
select b.*
from b 
)
select * from u
