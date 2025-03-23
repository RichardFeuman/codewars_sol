with sales_agg_by_dep as
       (
         select * from 
       (select  
              s.member_id,
              p.price,
              sum(p.price) over(partition by s.department_id) as total_per_dep
         from sales s join products p
         on p.id = s.product_id   
         ) x
         where total_per_dep > 10000
         
       ), sales_agg_by_mem as (
       
         select member_id, sum(price) as total_per_mem
         from sales_agg_by_dep
         group by member_id
         having sum(price) > 1000
       
       )
       select 
       mem.id,
       mem.name,
       mem.email,
       agg.total_per_mem total_spending
       from members mem join sales_agg_by_mem agg on mem.id = agg.member_id
order by id
