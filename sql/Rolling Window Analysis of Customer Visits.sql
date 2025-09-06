with nabla as (
select distinct date, 
       customer_id, 
       name, 
       array_agg(name) 
       over(partition by customer_id 
            order by date 
            RANGE BETWEEN INTERVAL '2 days' PRECEDING AND CURRENT ROW) as names
from 
customers)
select date, customer_id, name, array_length(array_agg(distinct u.val), 1) count
from nabla t
cross join lateral unnest(t.names) as u(val)
group by 1, 2, 3
order by 1, 2 desc, 3
