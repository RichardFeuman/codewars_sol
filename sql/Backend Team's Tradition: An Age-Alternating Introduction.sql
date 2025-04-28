with young as 
(select 
      employee_id,
      full_name,
      team,
      birth_date,
      dense_rank() over(order by birth_date desc) as rank_for_young,
      dense_rank() over(order by birth_date) as rank_for_old
from employees 
where team = 'backend'
)
select employee_id, full_name, team, birth_date
from young
order by abs(rank_for_old - rank_for_young) desc, rank_for_young
