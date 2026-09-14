USE Instagram;

-- User Engagement

-- 1. Total likes and comments
SELECT
    (SELECT COUNT(*) FROM Likes) AS total_likes,
    (SELECT COUNT(*) FROM Comments) AS total_comments;

-- 2. Likes given by each user
SELECT
    Users.ID,
    Users.User_name,
    COUNT(Likes.Photo_id) AS likes_given
FROM Users
LEFT JOIN Likes
    ON Users.ID = Likes.User_id
GROUP BY Users.ID, Users.User_name
ORDER BY likes_given DESC;

-- 3. Comments made by each user
SELECT
    Users.ID,
    Users.User_name,
    COUNT(Comments.ID) AS comments_made
FROM Users
LEFT JOIN Comments
    ON Users.ID = Comments.User_id
GROUP BY Users.ID, Users.User_name
ORDER BY comments_made DESC;

-- 4. Likes received by each user
SELECT
    Users.ID,
    Users.User_name,
    COUNT(Likes.Photo_id) AS likes_received
FROM Users
LEFT JOIN Photos
    ON Users.ID = Photos.User_ID
LEFT JOIN Likes
    ON Photos.ID = Likes.Photo_id
GROUP BY Users.ID, Users.User_name
ORDER BY likes_received DESC;

-- 5. Comments received by each user
SELECT
    Users.ID,
    Users.User_name,
    COUNT(Comments.ID) AS comments_received
FROM Users
LEFT JOIN Photos
    ON Users.ID = Photos.User_ID
LEFT JOIN Comments
    ON Photos.ID = Comments.Photo_id
GROUP BY Users.ID, Users.User_name
ORDER BY comments_received DESC;

-- 6. Average likes per photo
SELECT
    ROUND(AVG(like_count), 2) AS average_likes_per_photo
FROM (
    SELECT
        Photos.ID,
        COUNT(Likes.User_id) AS like_count
    FROM Photos
    LEFT JOIN Likes
        ON Photos.ID = Likes.Photo_id
    GROUP BY Photos.ID
) AS photo_likes;

-- 7. Average comments per photo
SELECT
    ROUND(AVG(comment_count), 2) AS average_comments_per_photo
FROM (
    SELECT
        Photos.ID,
        COUNT(Comments.ID) AS comment_count
    FROM Photos
    LEFT JOIN Comments
        ON Photos.ID = Comments.Photo_id
    GROUP BY Photos.ID
) AS photo_comments;
