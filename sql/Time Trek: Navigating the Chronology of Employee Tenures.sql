

with emp_info as (select 
      distinct              
      e.id,
      e.employee_name,
      case when 
           ew.finish_date 
           is not null and ew.id is not null then 'Left' 
           when ew.id is null then 'Never worked'
           when ew.finish_date is null then
           'Still with us' 
           end as status,
      ew.finish_date as finish_date,
      ew.start_date,
      coalesce(ew.finish_date, current_date) - ew.start_date  as total_duration,
      min(ew.start_date) over(partition by e.id) as first_start           
      --max(ew.start_date ) over(partition by e.id) as max_start_date,  
      --max(ew.finish_date ) over(partition by e.id) as max_finish_date             
from employee_works ew right join employees e
on ew.employee_id=e.id
), 
calc_durations as (
select distinct id,
         employee_name,
         first_value(status) 
         over(partition by id 
          order by 
          finish_date desc nulls first)  as status,
         case when 
         first_value(status) 
         over(partition by id 
          order by 
          finish_date desc nulls first) =  
          'Still with us' 
  then sum(total_duration) over(partition by id)
          else sum(finish_date - start_date) over(partition by id) end as total_duration
  from emp_info
  )
select id,
       employee_name,
       status,
       total_duration
from calc_durations 
order by id desc



