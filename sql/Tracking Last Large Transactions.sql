--var 1
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

--var 2

-- Substitute with your SQL

select at.*, (select max(at2.date) from account_transactions at2
             where at2.date <= at.date and at2.amount > 100 
              and at2.account_id = at.account_id) as last_over_hundred
from account_transactions at 
order by account_id desc,
         date asc
