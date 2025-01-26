select dense_rank() 
       over(order by engagement_points desc, date_joined, username) as rank,
       username,
       sc.engagement_points, 
       date_joined,
       github_handle from
(
select 
      u.likes_count * 1 + u.comments_count * 2 + u.shares_count * 3 +
      case when u.id in (select user_id from github_accounts) then 50 else 0 end
      as engagement_points,
      u.username,
      u.date_joined,
      g.github_handle

from users u left join 
     github_accounts g
     on u.id = g.user_id) sc
     order by engagement_points desc
     limit 10
