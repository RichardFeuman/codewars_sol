
with f as (
select distinct x.registered_at as date,
       count(u.id) over (partition by x.registered_at) sign_ups

          FROM (
              SELECT 
            generate_series(min(registered_at::date), max(registered_at::date), '1d')::date 
            AS registered_at
              FROM users
               ) x
          left join users u on u.registered_at::date = x.registered_at::date
)
select date,
       sign_ups,
       round(sum(sign_ups) over(order by date rows between 
               7 preceding and current row)*1.0/
       count(sign_ups) over(order by date rows between 
               7 preceding and current row), 2) 	avg_signups         
from f 
order by date
