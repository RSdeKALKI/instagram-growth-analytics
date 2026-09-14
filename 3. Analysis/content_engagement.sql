USE Instagram;

-- 1. How popular are posts based on total engagement?
SELECT
    Photos.ID AS photo_id,
    Users.User_name,
    COUNT(DISTINCT Likes.User_id) AS likes,
    COUNT(DISTINCT Comments.ID) AS comments,
    COUNT(DISTINCT Likes.User_id) + COUNT(DISTINCT Comments.ID)
        AS total_engagement,
    CASE
    WHEN COUNT(DISTINCT Likes.User_id) + COUNT(DISTINCT Comments.ID) BETWEEN 50 AND 55
        THEN 'Low'
    WHEN COUNT(DISTINCT Likes.User_id) + COUNT(DISTINCT Comments.ID) BETWEEN 56 AND 69
        THEN 'Moderate'
    WHEN COUNT(DISTINCT Likes.User_id) + COUNT(DISTINCT Comments.ID) >= 70
        THEN 'High'
END AS `Engagement level`
FROM Photos
JOIN Users
    ON Users.ID = Photos.User_ID
LEFT JOIN Likes
    ON Photos.ID = Likes.Photo_id
LEFT JOIN Comments
    ON Photos.ID = Comments.Photo_id
GROUP BY Photos.ID, Users.User_name
ORDER BY total_engagement DESC;

Results & Insights:
- Highest-engagement post: Photo 13 by Harley_Lind18 with 79 total engagements.
- Lowest-engagement post: Photo 1 by Kenton_Kirlin with 50 total engagements.
- 28 posts have high engagement, while only 14 posts have low engagement.
- 216 posts have moderate engagement, making it the dominant engagement level.
- All 258 posts received at least 50 total engagements, indicating consistent engagement across the available posts.
