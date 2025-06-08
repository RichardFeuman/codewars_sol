with lg as (

    select id, value, 
      lag(value) over(order by id) as prev_val, 
      lag(id) over(order by id) as prev_id
    from entries
  
), tokyo as (
select id, 
       value, 
  
  /*sum(case when prev_val = value and prev_id < id then 1 else 0 end)
over(order by value ) as grp*/
      count(*) filter (
      where (prev_val is null
      or prev_val != value)
        or (id is null or id - prev_id > 1)
    ) over (
      order by id
      rows between unbounded preceding
      and current row
    ) as grp
from lg
--order by id, value
)
select id, value, grp as run_id
--, ntile((select max(grp) from tokyo)::int) over(order by id, value) as grp2
from tokyo
order by id, value, grp
