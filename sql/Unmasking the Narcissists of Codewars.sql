WITH 

users_with_30_katas AS (
    SELECT 
        u.user_id,
        u.username,
        COUNT(DISTINCT s.kata_id) AS total_katas_solved
    FROM 
        users u
    JOIN 
        solutions s ON u.user_id = s.user_id
    GROUP BY 
        u.user_id, u.username
    HAVING 
        COUNT(DISTINCT s.kata_id) >= 30
),


self_voted_katas AS (
    SELECT 
        s.user_id,
        COUNT(DISTINCT s.kata_id) AS self_voted_katas_count
    FROM 
        solutions s
    JOIN 
        votes v ON s.solution_id = v.solution_id
    WHERE 
        s.user_id = v.voter_user_id  -- условие самоголосования
    GROUP BY 
        s.user_id
)


SELECT 
    u.user_id,
    u.username,
    ROUND(
        COALESCE(s.self_voted_katas_count, 0) * 100.0 / u.total_katas_solved, 
        2) AS self_vote_percentage
FROM 
    users_with_30_katas u
LEFT JOIN 
    self_voted_katas s ON u.user_id = s.user_id
WHERE 
    ROUND(
        COALESCE(s.self_voted_katas_count, 0) * 100.0 / u.total_katas_solved, 
        2) >= 25
ORDER BY 
    u.user_id DESC;
