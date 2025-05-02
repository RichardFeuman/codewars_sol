WITH actor_stats AS (
    SELECT 
        fa.actor_id,
        COUNT(DISTINCT fa.film_id) AS total_films,
        SUM(CASE WHEN film_rentals.rental_count < 7 OR 
            film_rentals.rental_count IS NULL THEN 1 ELSE 0 END) AS bad_films
    FROM 
        film_actor fa
    LEFT JOIN (
        SELECT 
            i.film_id,
            COUNT(DISTINCT r.rental_id) AS rental_count
        FROM 
            inventory i
        LEFT JOIN 
            rental r ON i.inventory_id = r.inventory_id
        GROUP BY 
            i.film_id
    ) film_rentals ON fa.film_id = film_rentals.film_id
    GROUP BY 
        fa.actor_id
)
SELECT 
    a.actor_id,
    a.first_name || ' ' || a.last_name AS full_name,
    s.total_films AS film_count
FROM 
    actor_stats s
JOIN 
    actor a ON s.actor_id = a.actor_id
WHERE 
    s.total_films >= 20
    AND s.bad_films = 0
ORDER BY 
    s.total_films DESC,
    a.actor_id ASC;
