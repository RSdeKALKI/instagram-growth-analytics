USE Instagram;

-- What is the average engagement received per post?
SELECT 
    ROUND(AVG(likes), 0) AS `Avg likes per post`,
    ROUND(AVG(comments), 0) AS `Avg comments per post`
FROM (
    SELECT
        Photos.ID,
        COUNT(DISTINCT Likes.User_id) AS likes,
        COUNT(DISTINCT Comments.User_id) AS comments
    FROM Photos
    LEFT JOIN Likes
        ON Photos.ID = Likes.Photo_id
    LEFT JOIN Comments
        ON Photos.ID = Comments.Photo_id
    GROUP BY Photos.ID
) AS `likes and comments`;

Results & Insights:
- Each post receives an average of 34 likes and 29 comments.
- Likes are the slightly larger source of engagement than comments.
- Together, a typical post receives approximately 63 likes and comments on average.
