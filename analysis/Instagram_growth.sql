USE instagram;

-- =====================================================
-- INSTAGRAM GROWTH
-- =====================================================

-- 1. Total registered users
SELECT 
    COUNT(*) AS total_users
FROM Users;


-- 2. User registrations by year
SELECT
    YEAR(Created_at) AS registration_year,
    COUNT(*) AS new_users
FROM Users
GROUP BY YEAR(Created_at)
ORDER BY registration_year;


-- 3. User registrations by month
SELECT
    YEAR(Created_at) AS registration_year,
    MONTH(Created_at) AS registration_month,
    MONTHNAME(Created_at) AS month_name,
    COUNT(*) AS new_users
FROM Users
GROUP BY
    YEAR(Created_at),
    MONTH(Created_at),
    MONTHNAME(Created_at)
ORDER BY
    registration_year,
    registration_month;


-- 4. Day of week with the most registrations
SELECT
    DAYNAME(Created_at) AS day_joined,
    COUNT(*) AS registrations
FROM Users
GROUP BY DAYOFWEEK(Created_at), DAYNAME(Created_at)
ORDER BY registrations DESC;


-- 5. Users who have never posted
SELECT
    u.ID,
    u.User_name
FROM Users u
LEFT JOIN Photos p
    ON u.ID = p.User_ID
WHERE p.ID IS NULL;


-- 6. Creator / activation rate
SELECT
    COUNT(DISTINCT p.User_ID) AS creators,
    COUNT(*) AS total_users,
    ROUND(
        COUNT(DISTINCT p.User_ID) * 100.0 / COUNT(*),
        2
    ) AS creator_rate_percent
FROM Users u
LEFT JOIN Photos p
    ON u.ID = p.User_ID;


-- 7. Number of posts per user
SELECT
    u.ID,
    u.User_name,
    COUNT(p.ID) AS total_posts
FROM Users u
LEFT JOIN Photos p
    ON u.ID = p.User_ID
GROUP BY u.ID, u.User_name
ORDER BY total_posts DESC;


-- 8. Time from signup to first post
SELECT
    u.ID,
    u.User_name,
    u.Created_at AS signup_date,
    MIN(p.Created_at) AS first_post_date,
    DATEDIFF(
        MIN(p.Created_at),
        u.Created_at
    ) AS days_to_first_post
FROM Users u
JOIN Photos p
    ON u.ID = p.User_ID
GROUP BY
    u.ID,
    u.User_name,
    u.Created_at
ORDER BY days_to_first_post;
