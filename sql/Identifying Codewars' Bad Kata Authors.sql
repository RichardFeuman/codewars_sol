-- Your SQL


select ka.user_id, 
        count(distinct kt.kata_id) as bad_kata_count
from
(
select kv.kata_id,
  sum(kv.vote) * 1.0 /count(kv.vote) as avg_vote,
count(kv.vote) vote_cnt
from kata_votes kv
  group by 1
) kt join kata_authors ka using(kata_id) 
where avg_vote < 0.7 and vote_cnt >= 3 
group by 1
having count(distinct kt.kata_id) >= 5
order by bad_kata_count desc, user_id desc










