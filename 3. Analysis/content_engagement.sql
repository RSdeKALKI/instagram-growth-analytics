USE Instagram;

-- Content Engagement

-- 1. Engagement for every photo
SELECT
    Photos.ID AS photo_id,
    Users.User_name,
    COALESCE(likes.likes, 0) AS likes,
    COALESCE(comments.comments, 0) AS comments,
    COALESCE(likes.likes, 0) + COALESCE(comments.comments, 0)
        AS total_engagement
FROM Photos
JOIN Users
    ON Users.ID = Photos.User_ID
LEFT JOIN (
    SELECT
        Photo_id,
        COUNT(*) AS likes
    FROM Likes
    GROUP BY Photo_id
) AS likes
    ON Photos.ID = likes.Photo_id
LEFT JOIN (
    SELECT
        Photo_id,
        COUNT(*) AS comments
    FROM Comments
    GROUP BY Photo_id
) AS comments
    ON Photos.ID = comments.Photo_id
ORDER BY total_engagement DESC;

-- 2. Top 10 photos by total engagement
SELECT
    Photos.ID AS photo_id,
    Users.User_name,
    COALESCE(likes.likes, 0) AS likes,
    COALESCE(comments.comments, 0) AS comments,
    COALESCE(likes.likes, 0) + COALESCE(comments.comments, 0)
        AS total_engagement
FROM Photos
JOIN Users
    ON Users.ID = Photos.User_ID
LEFT JOIN (
    SELECT Photo_id, COUNT(*) AS likes
    FROM Likes
    GROUP BY Photo_id
) AS likes
    ON Photos.ID = likes.Photo_id
LEFT JOIN (
    SELECT Photo_id, COUNT(*) AS comments
    FROM Comments
    GROUP BY Photo_id
) AS comments
    ON Photos.ID = comments.Photo_id
ORDER BY total_engagement DESC
LIMIT 10;

-- 3. Photos with zero engagement
SELECT
    Photos.ID AS photo_id,
    Users.User_name
FROM Photos
JOIN Users
    ON Users.ID = Photos.User_ID
LEFT JOIN (
    SELECT Photo_id, COUNT(*) AS likes
    FROM Likes
    GROUP BY Photo_id
) AS likes
    ON Photos.ID = likes.Photo_id
LEFT JOIN (
    SELECT Photo_id, COUNT(*) AS comments
    FROM Comments
    GROUP BY Photo_id
) AS comments
    ON Photos.ID = comments.Photo_id
WHERE COALESCE(likes.likes, 0) + COALESCE(comments.comments, 0) = 0;

-- 4. Engagement distribution
SELECT
    CASE
        WHEN total_engagement = 0 THEN '0'
        WHEN total_engagement BETWEEN 1 AND 5 THEN '1-5'
        WHEN total_engagement BETWEEN 6 AND 10 THEN '6-10'
        WHEN total_engagement BETWEEN 11 AND 25 THEN '11-25'
        ELSE '26+'
    END AS engagement_bucket,
    COUNT(*) AS photos
FROM (
    SELECT
        Photos.ID,
        COALESCE(likes.likes, 0) + COALESCE(comments.comments, 0)
            AS total_engagement
    FROM Photos
    LEFT JOIN (
        SELECT Photo_id, COUNT(*) AS likes
        FROM Likes
        GROUP BY Photo_id
    ) AS likes
        ON Photos.ID = likes.Photo_id
    LEFT JOIN (
        SELECT Photo_id, COUNT(*) AS comments
        FROM Comments
        GROUP BY Photo_id
    ) AS comments
        ON Photos.ID = comments.Photo_id
) AS photo_metrics
GROUP BY engagement_bucket
ORDER BY MIN(
    CASE engagement_bucket
        WHEN '0' THEN 0
        WHEN '1-5' THEN 1
        WHEN '6-10' THEN 2
        WHEN '11-25' THEN 3
        WHEN '26+' THEN 4
    END
);
