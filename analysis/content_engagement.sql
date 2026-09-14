USE instagram;

-- =====================================================
-- CONTENT ENGAGEMENT
-- =====================================================

-- 1. Engagement for every photo
SELECT
    p.ID AS photo_id,
    u.User_name,
    COUNT(DISTINCT l.User_id) AS likes,
    COUNT(DISTINCT c.ID) AS comments,
    COUNT(DISTINCT l.User_id)
        + COUNT(DISTINCT c.ID) AS total_engagement
FROM Photos p
JOIN Users u
    ON p.User_ID = u.ID
LEFT JOIN Likes l
    ON p.ID = l.Photo_id
LEFT JOIN Comments c
    ON p.ID = c.Photo_id
GROUP BY p.ID, u.User_name
ORDER BY total_engagement DESC;


-- 2. Top 10 photos by engagement
SELECT
    p.ID AS photo_id,
    u.User_name,
    COUNT(DISTINCT l.User_id)
        + COUNT(DISTINCT c.ID) AS total_engagement
FROM Photos p
JOIN Users u
    ON p.User_ID = u.ID
LEFT JOIN Likes l
    ON p.ID = l.Photo_id
LEFT JOIN Comments c
    ON p.ID = c.Photo_id
GROUP BY p.ID, u.User_name
ORDER BY total_engagement DESC
LIMIT 10;


-- 3. Photos with zero engagement
SELECT
    p.ID AS photo_id,
    u.User_name
FROM Photos p
JOIN Users u
    ON p.User_ID = u.ID
LEFT JOIN Likes l
    ON p.ID = l.Photo_id
LEFT JOIN Comments c
    ON p.ID = c.Photo_id
GROUP BY p.ID, u.User_name
HAVING COUNT(DISTINCT l.User_id)
     + COUNT(DISTINCT c.ID) = 0;


-- 4. Average engagement by posting month
SELECT
    YEAR(p.Created_at) AS year_posted,
    MONTH(p.Created_at) AS month_posted,
    MONTHNAME(p.Created_at) AS month_name,
    ROUND(
        (
            COUNT(DISTINCT l.User_id)
            + COUNT(DISTINCT c.ID)
        ) * 1.0 / COUNT(DISTINCT p.ID),
        2
    ) AS avg_engagement_per_post
FROM Photos p
LEFT JOIN Likes l
    ON p.ID = l.Photo_id
LEFT JOIN Comments c
    ON p.ID = c.Photo_id
GROUP BY
    YEAR(p.Created_at),
    MONTH(p.Created_at),
    MONTHNAME(p.Created_at)
ORDER BY year_posted, month_posted;


-- 5. Distribution of photos by engagement level
SELECT
    CASE
        WHEN engagement = 0 THEN '0'
        WHEN engagement BETWEEN 1 AND 5 THEN '1-5'
        WHEN engagement BETWEEN 6 AND 10 THEN '6-10'
        WHEN engagement BETWEEN 11 AND 25 THEN '11-25'
        ELSE '26+'
    END AS engagement_bucket,
    COUNT(*) AS photos
FROM (
    SELECT
        p.ID,
        COUNT(DISTINCT l.User_id)
        + COUNT(DISTINCT c.ID) AS engagement
    FROM Photos p
    LEFT JOIN Likes l
        ON p.ID = l.Photo_id
    LEFT JOIN Comments c
        ON p.ID = c.Photo_id
    GROUP BY p.ID
) x
GROUP BY engagement_bucket
ORDER BY MIN(
    CASE engagement_bucket
        WHEN '0' THEN 0
        WHEN '1-5' THEN 1
        WHEN '6-10' THEN 2
        WHEN '11-25' THEN 3
        ELSE 4
    END
);
