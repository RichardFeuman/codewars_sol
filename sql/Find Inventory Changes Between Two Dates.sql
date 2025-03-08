prepare find_inventory_changes(date, date) as
-- your SQL

with on_first_dt as (
  
    select 
      product_id,
      product_size
  
    from inventory where inventory_date = $1

  ), on_second_dt as (
  
    select 
      product_id,
      product_size
      
    from inventory where inventory_date = $2

  )
  select coalesce(ss.product_id, fs.product_id) product_id,
         coalesce(ss.product_size, fs.product_size) product_size,
         case when fs.product_id is null and fs.product_size is null then 'added' 
              when ss.product_id is null and ss.product_size is null then 'removed' 
              end as change_type
  from on_first_dt fs full join on_second_dt ss
  on fs.product_id = ss.product_id
  and fs.product_size = ss.product_size
  WHERE fs.product_id IS NULL OR ss.product_id IS NULL
ORDER BY product_id DESC, product_size ASC;
  
         
         
         
