USE instagram;

-- =====================================================
-- USER SEGMENTATION
-- =====================================================

-- 1. Segment users by content creation
SELECT
    u.ID,
    u.User_name,
    COUNT(p.ID) AS posts,
    CASE
        WHEN COUNT(p.ID) = 0 THEN 'Consumer'
        WHEN COUNT(p.ID) BETWEEN 1 AND 5 THEN 'Light Creator'
        WHEN COUNT(p.ID) BETWEEN 6 AND 10 THEN 'Regular Creator'
        ELSE 'Power Creator'
    END AS creator_segment
FROM Users u
LEFT JOIN Photos p
    ON u.ID = p.User_ID
GROUP BY u.ID, u.User_name
ORDER BY posts DESC;


-- 2. Segment users by likes given
SELECT
    u.ID,
    u.User_name,
    COUNT(l.Photo_id) AS likes_given,
    CASE
        WHEN COUNT(l.Photo_id) = 0 THEN 'Inactive'
        WHEN COUNT(l.Photo_id) BETWEEN 1 AND 10 THEN 'Low Engagement'
        WHEN COUNT(l.Photo_id) BETWEEN 11 AND 50 THEN 'Moderate Engagement'
        ELSE 'High Engagement'
    END AS engagement_segment
FROM Users u
LEFT JOIN Likes l
    ON u.ID = l.User_id
GROUP BY u.ID, u.User_name
ORDER BY likes_given DESC;


-- 3. Combined behavioral segmentation
SELECT
    u.ID,
    u.User_name,
    COUNT(DISTINCT p.ID) AS posts,
    COUNT(DISTINCT l.Photo_id) AS likes_given,
    COUNT(DISTINCT c.ID) AS comments_made,
    COUNT(DISTINCT f.Followee_id) AS following,
    CASE
        WHEN COUNT(DISTINCT p.ID) = 0
             AND COUNT(DISTINCT l.Photo_id) = 0
             AND COUNT(DISTINCT c.ID) = 0
            THEN 'Inactive'
            
        WHEN COUNT(DISTINCT p.ID) > 0
             AND (
                 COUNT(DISTINCT l.Photo_id)
                 + COUNT(DISTINCT c.ID)
             ) > 0
            THEN 'Creator & Engager'
            
        WHEN COUNT(DISTINCT p.ID) > 0
            THEN 'Creator'
            
        WHEN (
            COUNT(DISTINCT l.Photo_id)
            + COUNT(DISTINCT c.ID)
        ) > 0
            THEN 'Consumer & Engager'
            
        ELSE 'Consumer'
    END AS user_segment
FROM Users u
LEFT JOIN Photos p
    ON u.ID = p.User_ID
LEFT JOIN Likes l
    ON u.ID = l.User_id
LEFT JOIN Comments c
    ON u.ID = c.User_id
LEFT JOIN Follows f
    ON u.ID = f.Follower_id
GROUP BY u.ID, u.User_name
ORDER BY u.ID;


-- 4. Size of each user segment
SELECT
    user_segment,
    COUNT(*) AS users
FROM (
    SELECT
        u.ID,
        CASE
            WHEN COUNT(DISTINCT p.ID) = 0
                 AND COUNT(DISTINCT l.Photo_id) = 0
                 AND COUNT(DISTINCT c.ID) = 0
                THEN 'Inactive'
            WHEN COUNT(DISTINCT p.ID) > 0
                 AND (
                     COUNT(DISTINCT l.Photo_id)
                     + COUNT(DISTINCT c.ID)
                 ) > 0
                THEN 'Creator & Engager'
            WHEN COUNT(DISTINCT p.ID) > 0
                THEN 'Creator'
            WHEN (
                COUNT(DISTINCT l.Photo_id)
                + COUNT(DISTINCT c.ID)
            ) > 0
                THEN 'Consumer & Engager'
            ELSE 'Consumer'
        END AS user_segment
    FROM Users u
    LEFT JOIN Photos p
        ON u.ID = p.User_ID
    LEFT JOIN Likes l
        ON u.ID = l.User_id
    LEFT JOIN Comments c
        ON u.ID = c.User_id
    GROUP BY u.ID
) x
GROUP BY user_segment
ORDER BY users DESC;
