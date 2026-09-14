USE Instagram;

-- Creator & Content Performance

-- 1. Top creators by number of posts
SELECT
    Users.ID,
    Users.User_name,
    COUNT(Photos.ID) AS total_posts
FROM Users
JOIN Photos
    ON Users.ID = Photos.User_ID
GROUP BY Users.ID, Users.User_name
ORDER BY total_posts DESC
LIMIT 10;

-- 2. Creator performance: posts, likes received and comments received
SELECT
    Users.ID,
    Users.User_name,
    COUNT(Photos.ID) AS total_posts,
    COALESCE(likes.likes_received, 0) AS likes_received,
    COALESCE(comments.comments_received, 0) AS comments_received
FROM Users
JOIN Photos
    ON Users.ID = Photos.User_ID
LEFT JOIN (
    SELECT
        Photos.User_ID,
        COUNT(Likes.User_id) AS likes_received
    FROM Photos
    LEFT JOIN Likes
        ON Photos.ID = Likes.Photo_id
    GROUP BY Photos.User_ID
) AS likes
    ON Users.ID = likes.User_ID
LEFT JOIN (
    SELECT
        Photos.User_ID,
        COUNT(Comments.ID) AS comments_received
    FROM Photos
    LEFT JOIN Comments
        ON Photos.ID = Comments.Photo_id
    GROUP BY Photos.User_ID
) AS comments
    ON Users.ID = comments.User_ID
GROUP BY
    Users.ID,
    Users.User_name,
    likes.likes_received,
    comments.comments_received
ORDER BY likes_received DESC;

-- 3. Average engagement per post by creator
SELECT
    Users.ID,
    Users.User_name,
    COUNT(Photos.ID) AS total_posts,
    ROUND(
        (
            COALESCE(likes.likes_received, 0)
            + COALESCE(comments.comments_received, 0)
        ) * 1.0 / COUNT(Photos.ID),
        2
    ) AS avg_engagement_per_post
FROM Users
JOIN Photos
    ON Users.ID = Photos.User_ID
LEFT JOIN (
    SELECT
        Photos.User_ID,
        COUNT(Likes.User_id) AS likes_received
    FROM Photos
    LEFT JOIN Likes
        ON Photos.ID = Likes.Photo_id
    GROUP BY Photos.User_ID
) AS likes
    ON Users.ID = likes.User_ID
LEFT JOIN (
    SELECT
        Photos.User_ID,
        COUNT(Comments.ID) AS comments_received
    FROM Photos
    LEFT JOIN Comments
        ON Photos.ID = Comments.Photo_id
    GROUP BY Photos.User_ID
) AS comments
    ON Users.ID = comments.User_ID
GROUP BY
    Users.ID,
    Users.User_name,
    likes.likes_received,
    comments.comments_received
ORDER BY avg_engagement_per_post DESC;

-- 4. Top 10 photos by likes
SELECT
    Users.User_name,
    Photos.ID AS photo_id,
    Photos.Image_url,
    COUNT(Likes.User_id) AS likes
FROM Photos
JOIN Likes
    ON Photos.ID = Likes.Photo_id
JOIN Users
    ON Users.ID = Photos.User_ID
GROUP BY
    Photos.ID,
    Users.User_name,
    Photos.Image_url
ORDER BY likes DESC
LIMIT 10;

-- 5. Top 10 photos by comments
SELECT
    Users.User_name,
    Photos.ID AS photo_id,
    Photos.Image_url,
    COUNT(Comments.ID) AS comments
FROM Photos
JOIN Comments
    ON Photos.ID = Comments.Photo_id
JOIN Users
    ON Users.ID = Photos.User_ID
GROUP BY
    Photos.ID,
    Users.User_name,
    Photos.Image_url
ORDER BY comments DESC
LIMIT 10;
