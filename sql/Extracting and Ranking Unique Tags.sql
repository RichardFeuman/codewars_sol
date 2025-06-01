select dense_rank() over(order by count(*) desc, tag) as tag_rank, 
       tag, 
       count(*) as tag_count
       from
(
select user_id, unnest(string_to_array(tags, ',')) as tag
  from user_tags) tokyo
group by tag
