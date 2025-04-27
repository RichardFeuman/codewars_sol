
select
      to_char(sale_time, 'yyyy-mm-dd hh24:mi:ss') sale_time,
      product_id,
      price,
      review_rating
      from 
(select 
       distinct s.id, s.sale_time sale_time, s.sale_time sale_time2,
       --date_format(s.sale_time, 'yyyy-MM-dd HH24:MM:SS') sale_time,
       s.product_id,
       first_value(pp.price) 
        over(partition by pp.product_id order by pp.price_time desc, s.id desc) price,
       first_value(cr.review_rating)
        over(partition by cr.product_id order by cr.review_time desc, s.id desc) as review_rating
from 
sales s join
product_prices pp on s.product_id = pp.product_id
  left join customer_reviews cr on s.product_id = cr.product_id
  and cr.review_time <= s.sale_time
  where pp.price_time <= s.sale_time) c
order by c.sale_time2 desc, c.id desc
