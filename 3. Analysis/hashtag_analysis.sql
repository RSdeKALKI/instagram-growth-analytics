USE Instagram;

-- Hashtag & Content Discovery

-- 1. Most-used hashtags
SELECT
    Tags.ID AS tag_id,
    Tags.Tag_name,
    COUNT(Photo_tags.Photo_id) AS photos_using_tag
FROM Tags
LEFT JOIN Photo_tags
    ON Tags.ID = Photo_tags.Tag_id
GROUP BY Tags.ID, Tags.Tag_name
ORDER BY photos_using_tag DESC;

-- 2. Top 5 most commonly used hashtags
SELECT
    Tags.Tag_name,
    COUNT(Photo_tags.Photo_id) AS photos_using_tag
FROM Tags
JOIN Photo_tags
    ON Tags.ID = Photo_tags.Tag_id
GROUP BY Tags.ID, Tags.Tag_name
ORDER BY photos_using_tag DESC
LIMIT 5;

-- 3. Most engaging hashtags
SELECT
    Tags.Tag_name,
    COUNT(DISTINCT Photo_tags.Photo_id) AS photos_using_tag,
    COALESCE(SUM(photo_metrics.likes), 0) AS likes,
    COALESCE(SUM(photo_metrics.comments), 0) AS comments,
    COALESCE(SUM(photo_metrics.likes), 0)
        + COALESCE(SUM(photo_metrics.comments), 0)
        AS total_engagement
FROM Tags
JOIN Photo_tags
    ON Tags.ID = Photo_tags.Tag_id
JOIN (
    SELECT
        Photos.ID AS photo_id,
        COALESCE(likes.likes, 0) AS likes,
        COALESCE(comments.comments, 0) AS comments
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
    ON Photo_tags.Photo_id = photo_metrics.photo_id
GROUP BY Tags.ID, Tags.Tag_name
ORDER BY total_engagement DESC;

-- 4. Average engagement per hashtagged photo
SELECT
    Tags.Tag_name,
    COUNT(DISTINCT Photo_tags.Photo_id) AS photos_using_tag,
    ROUND(AVG(photo_metrics.likes + photo_metrics.comments), 2)
        AS avg_engagement_per_photo
FROM Tags
JOIN Photo_tags
    ON Tags.ID = Photo_tags.Tag_id
JOIN (
    SELECT
        Photos.ID AS photo_id,
        COALESCE(likes.likes, 0) AS likes,
        COALESCE(comments.comments, 0) AS comments
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
    ON Photo_tags.Photo_id = photo_metrics.photo_id
GROUP BY Tags.ID, Tags.Tag_name
ORDER BY avg_engagement_per_photo DESC;

-- 5. Top user for the beach hashtag
SELECT
    Users.User_name,
    COUNT(*) AS beach_posts
FROM Photo_tags
JOIN Tags
    ON Photo_tags.Tag_id = Tags.ID
JOIN Photos
    ON Photos.ID = Photo_tags.Photo_id
JOIN Users
    ON Users.ID = Photos.User_ID
WHERE Tags.Tag_name = 'beach'
GROUP BY Users.ID, Users.User_name
ORDER BY beach_posts DESC
LIMIT 1;
