-- Substitute with your SQL

with c1 as (
select store_id,
       product_id,
       transaction_date,
       quantity,
       sum(quantity) over(partition by transaction_date, store_id, product_id) qnty
from sales
), c2 as (

select 
         distinct 
         store_id, 
         product_id,
         transaction_date,
         quantity,
         rn
         
  from 
  (
  select store_id,
         product_id,
         transaction_date,
         quantity,
         row_number() over(partition by transaction_date, 
                           store_id, product_id order by quantity desc, 
                           transaction_date) as rn
    from c1
  ) x 
  where rn = 1
--group by 1, 2
), c3 as (

  select 
         store_id, 
         product_id,
         transaction_date,
         quantity,
         rn,
         dense_rank() over(partition by store_id, product_id order by 
                           quantity desc, transaction_date) as rn2
  from c2


)

select distinct 
       c1.store_id, 
       c1.product_id, 
       c1.transaction_date, 
       c3.quantity max_quantity,
       c1.qnty as total_quantity_on_max_day
from c1 join c3 using(store_id, product_id, transaction_date)
where c3.rn2 = 1
order by store_id, product_id
--select * from c3
       
