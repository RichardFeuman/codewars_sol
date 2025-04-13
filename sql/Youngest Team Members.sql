
select employee_id,
       full_name,
       team,
       birth_date
from 
(
select 
      employee_id,
      full_name,
      team,
      birth_date,
      dense_rank() over(partition by team order by birth_date desc) dr
from employees
) x
where dr = 1
