
--var 1
select distinct cat.name category_name,
     f.rating 	film_rating, 
     round(array_length(array_agg(f.film_id) over(partition by 
          cat.name,              
          f.rating), 1) *100.0 / 
          array_length(array_agg(f.film_id) over(partition by 
          cat.name              
          ), 1
                      ), 3)::numeric  percentage
from category cat join
film_category fc using(category_id) 
join film f using(film_id)
order by category_name asc, percentage desc,
rating

--var 2

select distinct cat.name category_name,
     f.rating 	film_rating, 
     cast(round(count(*) 
     over(partition by 
          cat.name, 
          f.rating)*100.0/
           count(*) 
     over(partition by 
          cat.name), 3) as numeric) as percentage
from category cat join
film_category fc using(category_id) 
join film f using(film_id)
order by category_name asc, percentage desc,
rating
