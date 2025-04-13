
-- Substitute with your SQL


with classes as (
select user_id, 
       array_agg(distinct class) as class_arr
from users
group by user_id
), classification as (
  
  select user_id, 
         case when array_to_string(class_arr , '') = 'a' then 'a'
              when array_length(class_arr, 1) = 2 then 'b'
              when array_to_string(class_arr , '') = 'b' then 'b'
         end as class
  from classes
)
select class, count(distinct user_id)
from classification
group by class
