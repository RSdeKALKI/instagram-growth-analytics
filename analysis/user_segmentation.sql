USE Instagram;

-- User Segmentation

-- 1. Segment users by content creation
SELECT
    Users.ID,
    Users.User_name,
    COUNT(Photos.ID) AS posts,
    CASE
        WHEN COUNT(Photos.ID) = 0 THEN 'Consumer'
        WHEN COUNT(Photos.ID) BETWEEN 1 AND 5 THEN 'Light Creator'
        WHEN COUNT(Photos.ID) BETWEEN 6 AND 10 THEN 'Regular Creator'
        ELSE 'Power Creator'
    END AS creator_segment
FROM Users
LEFT JOIN Photos
    ON Users.ID = Photos.User_ID
GROUP BY Users.ID, Users.User_name
ORDER BY posts DESC;

-- 2. Segment users by likes given
SELECT
    Users.ID,
    Users.User_name,
    COUNT(Likes.Photo_id) AS likes_given,
    CASE
        WHEN COUNT(Likes.Photo_id) = 0 THEN 'Inactive'
        WHEN COUNT(Likes.Photo_id) BETWEEN 1 AND 10 THEN 'Low Engagement'
        WHEN COUNT(Likes.Photo_id) BETWEEN 11 AND 50 THEN 'Moderate Engagement'
        ELSE 'High Engagement'
    END AS engagement_segment
FROM Users
LEFT JOIN Likes
    ON Users.ID = Likes.User_id
GROUP BY Users.ID, Users.User_name
ORDER BY likes_given DESC;

-- 3. Behavioral segmentation using posts, likes given and comments made
WITH user_activity AS (
    SELECT
        Users.ID,
        Users.User_name,
        COALESCE(posts.posts, 0) AS posts,
        COALESCE(likes.likes_given, 0) AS likes_given,
        COALESCE(comments.comments_made, 0) AS comments_made
    FROM Users
    LEFT JOIN (
        SELECT User_ID, COUNT(*) AS posts
        FROM Photos
        GROUP BY User_ID
    ) AS posts
        ON Users.ID = posts.User_ID
    LEFT JOIN (
        SELECT User_id, COUNT(*) AS likes_given
        FROM Likes
        GROUP BY User_id
    ) AS likes
        ON Users.ID = likes.User_id
    LEFT JOIN (
        SELECT User_id, COUNT(*) AS comments_made
        FROM Comments
        GROUP BY User_id
    ) AS comments
        ON Users.ID = comments.User_id
)
SELECT
    ID,
    User_name,
    posts,
    likes_given,
    comments_made,
    CASE
        WHEN posts = 0
             AND likes_given = 0
             AND comments_made = 0
            THEN 'Inactive'
        WHEN posts > 0
             AND likes_given + comments_made > 0
            THEN 'Creator & Engager'
        WHEN posts > 0
            THEN 'Creator'
        WHEN likes_given + comments_made > 0
            THEN 'Consumer & Engager'
        ELSE 'Consumer'
    END AS user_segment
FROM user_activity
ORDER BY ID;

-- 4. Number of users in each behavioral segment
WITH user_activity AS (
    SELECT
        Users.ID,
        COALESCE(posts.posts, 0) AS posts,
        COALESCE(likes.likes_given, 0) AS likes_given,
        COALESCE(comments.comments_made, 0) AS comments_made
    FROM Users
    LEFT JOIN (
        SELECT User_ID, COUNT(*) AS posts
        FROM Photos
        GROUP BY User_ID
    ) AS posts
        ON Users.ID = posts.User_ID
    LEFT JOIN (
        SELECT User_id, COUNT(*) AS likes_given
        FROM Likes
        GROUP BY User_id
    ) AS likes
        ON Users.ID = likes.User_id
    LEFT JOIN (
        SELECT User_id, COUNT(*) AS comments_made
        FROM Comments
        GROUP BY User_id
    ) AS comments
        ON Users.ID = comments.User_id
),
segmented_users AS (
    SELECT
        CASE
            WHEN posts = 0
                 AND likes_given = 0
                 AND comments_made = 0
                THEN 'Inactive'
            WHEN posts > 0
                 AND likes_given + comments_made > 0
                THEN 'Creator & Engager'
            WHEN posts > 0
                THEN 'Creator'
            WHEN likes_given + comments_made > 0
                THEN 'Consumer & Engager'
            ELSE 'Consumer'
        END AS user_segment
    FROM user_activity
)
SELECT
    user_segment,
    COUNT(*) AS users
FROM segmented_users
GROUP BY user_segment
ORDER BY users DESC;
