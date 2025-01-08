with y as (
select   date          
       , account_id       
       , amount          
       , last_value(case when amount > 100 then date else null end)
         over(partition by account_id order by date 
             rows between unbounded preceding and current row)
from account_transactions
 order by account_id desc, date asc
)
select date          
       , account_id       
       , amount   
       , max(last_value) over(partition by account_id order by date) last_over_hundred
from y
order by account_id desc, date asc
