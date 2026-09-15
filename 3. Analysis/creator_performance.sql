USE Instagram;

-- Creator & Content Performance

-- 1. Which creators generate the highest total engagement?
SELECT
    Users.ID,
    Users.User_name,
    COUNT(Photos.ID) AS total_posts,
    COALESCE(likes.likes_received, 0) AS likes_received,
    COALESCE(comments.comments_received, 0) AS comments_received,
    COALESCE(likes.likes_received, 0)
        + COALESCE(comments.comments_received, 0) AS total_engagement
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
ORDER BY total_engagement DESC;

Results & Insights:
- Eveline95 generates the highest total engagement with 749 across 12 posts.
- Clint27 follows with 660, and Cesar93 with 646.
