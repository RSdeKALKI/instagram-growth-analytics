USE instagram;

-- =====================================================
-- USER ENGAGEMENT
-- =====================================================

-- 1. Total likes and comments
SELECT
    (SELECT COUNT(*) FROM Likes) AS total_likes,
    (SELECT COUNT(*) FROM Comments) AS total_comments;


-- 2. Likes received by each user
SELECT
    u.ID,
    u.User_name,
    COUNT(l.Photo_id) AS likes_received
FROM Users u
LEFT JOIN Photos p
    ON u.ID = p.User_ID
LEFT JOIN Likes l
    ON p.ID = l.Photo_id
GROUP BY u.ID, u.User_name
ORDER BY likes_received DESC;


-- 3. Comments received by each user
SELECT
    u.ID,
    u.User_name,
    COUNT(c.ID) AS comments_received
FROM Users u
LEFT JOIN Photos p
    ON u.ID = p.User_ID
LEFT JOIN Comments c
    ON p.ID = c.Photo_id
GROUP BY u.ID, u.User_name
ORDER BY comments_received DESC;


-- 4. Likes given by each user
SELECT
    u.ID,
    u.User_name,
    COUNT(l.Photo_id) AS likes_given
FROM Users u
LEFT JOIN Likes l
    ON u.ID = l.User_id
GROUP BY u.ID, u.User_name
ORDER BY likes_given DESC;


-- 5. Comments made by each user
SELECT
    u.ID,
    u.User_name,
    COUNT(c.ID) AS comments_made
FROM Users u
LEFT JOIN Comments c
    ON u.ID = c.User_id
GROUP BY u.ID, u.User_name
ORDER BY comments_made DESC;


-- 6. Posts, likes and comments per user
SELECT
    u.ID,
    u.User_name,
    COUNT(DISTINCT p.ID) AS posts,
    COUNT(DISTINCT l.Photo_id) AS likes_given,
    COUNT(DISTINCT c.ID) AS comments_made
FROM Users u
LEFT JOIN Photos p
    ON u.ID = p.User_ID
LEFT JOIN Likes l
    ON u.ID = l.User_id
LEFT JOIN Comments c
    ON u.ID = c.User_id
GROUP BY u.ID, u.User_name
ORDER BY posts DESC;


-- 7. Average likes per photo
SELECT
    ROUND(AVG(like_count), 2) AS average_likes_per_photo
FROM (
    SELECT
        p.ID,
        COUNT(l.User_id) AS like_count
    FROM Photos p
    LEFT JOIN Likes l
        ON p.ID = l.Photo_id
    GROUP BY p.ID
) x;


-- 8. Average comments per photo
SELECT
    ROUND(AVG(comment_count), 2) AS average_comments_per_photo
FROM (
    SELECT
        p.ID,
        COUNT(c.ID) AS comment_count
    FROM Photos p
    LEFT JOIN Comments c
        ON p.ID = c.Photo_id
    GROUP BY p.ID
) x;


-- 9. User engagement profile
SELECT
    u.ID,
    u.User_name,
    COUNT(DISTINCT p.ID) AS posts,
    COUNT(DISTINCT l.Photo_id) AS likes_given,
    COUNT(DISTINCT c.ID) AS comments_made,
    COUNT(DISTINCT l.Photo_id)
        + COUNT(DISTINCT c.ID) AS total_interactions
FROM Users u
LEFT JOIN Photos p
    ON u.ID = p.User_ID
LEFT JOIN Likes l
    ON u.ID = l.User_id
LEFT JOIN Comments c
    ON u.ID = c.User_id
GROUP BY u.ID, u.User_name
ORDER BY total_interactions DESC;
