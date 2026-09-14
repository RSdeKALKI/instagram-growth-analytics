USE instagram;

-- =====================================================
-- CREATOR & CONTENT PERFORMANCE
-- =====================================================

-- 1. Top creators by number of posts
SELECT
    u.ID,
    u.User_name,
    COUNT(p.ID) AS total_posts
FROM Users u
JOIN Photos p
    ON u.ID = p.User_ID
GROUP BY u.ID, u.User_name
ORDER BY total_posts DESC;


-- 2. Creator performance: posts, likes and comments
SELECT
    u.ID,
    u.User_name,
    COUNT(DISTINCT p.ID) AS total_posts,
    COUNT(DISTINCT l.User_id) AS total_likes_received,
    COUNT(DISTINCT c.ID) AS total_comments_received
FROM Users u
JOIN Photos p
    ON u.ID = p.User_ID
LEFT JOIN Likes l
    ON p.ID = l.Photo_id
LEFT JOIN Comments c
    ON p.ID = c.Photo_id
GROUP BY u.ID, u.User_name
ORDER BY total_likes_received DESC;


-- 3. Average engagement per post by creator
SELECT
    u.ID,
    u.User_name,
    COUNT(DISTINCT p.ID) AS total_posts,
    COUNT(DISTINCT l.User_id) AS total_likes,
    COUNT(DISTINCT c.ID) AS total_comments,
    ROUND(
        (
            COUNT(DISTINCT l.User_id)
            + COUNT(DISTINCT c.ID)
        ) / COUNT(DISTINCT p.ID),
        2
    ) AS avg_engagement_per_post
FROM Users u
JOIN Photos p
    ON u.ID = p.User_ID
LEFT JOIN Likes l
    ON p.ID = l.Photo_id
LEFT JOIN Comments c
    ON p.ID = c.Photo_id
GROUP BY u.ID, u.User_name
ORDER BY avg_engagement_per_post DESC;


-- 4. Most liked individual photos
SELECT
    p.ID AS photo_id,
    u.User_name,
    COUNT(l.User_id) AS likes
FROM Photos p
JOIN Users u
    ON p.User_ID = u.ID
LEFT JOIN Likes l
    ON p.ID = l.Photo_id
GROUP BY p.ID, u.User_name
ORDER BY likes DESC
LIMIT 10;


-- 5. Most commented individual photos
SELECT
    p.ID AS photo_id,
    u.User_name,
    COUNT(c.ID) AS comments
FROM Photos p
JOIN Users u
    ON p.User_ID = u.ID
LEFT JOIN Comments c
    ON p.ID = c.Photo_id
GROUP BY p.ID, u.User_name
ORDER BY comments DESC
LIMIT 10;


-- 6. Creator output vs engagement
SELECT
    u.User_name,
    COUNT(DISTINCT p.ID) AS posts,
    COUNT(DISTINCT l.User_id) AS likes_received,
    ROUND(
        COUNT(DISTINCT l.User_id) * 1.0
        / COUNT(DISTINCT p.ID),
        2
    ) AS likes_per_post
FROM Users u
JOIN Photos p
    ON u.ID = p.User_ID
LEFT JOIN Likes l
    ON p.ID = l.Photo_id
GROUP BY u.ID, u.User_name
ORDER BY likes_per_post DESC;
