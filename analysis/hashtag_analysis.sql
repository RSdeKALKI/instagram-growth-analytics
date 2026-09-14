USE instagram;

-- =====================================================
-- HASHTAG & CONTENT DISCOVERY
-- =====================================================

-- 1. Most-used hashtags
SELECT
    t.ID AS tag_id,
    t.Tag_name,
    COUNT(pt.Photo_id) AS photos_using_tag
FROM tags t
LEFT JOIN Photo_tags pt
    ON t.ID = pt.Tag_id
GROUP BY t.ID, t.Tag_name
ORDER BY photos_using_tag DESC;


-- 2. Top 5 hashtags by usage
SELECT
    t.Tag_name,
    COUNT(pt.Photo_id) AS photos_using_tag
FROM tags t
JOIN Photo_tags pt
    ON t.ID = pt.Tag_id
GROUP BY t.ID, t.Tag_name
ORDER BY photos_using_tag DESC
LIMIT 5;


-- 3. Engagement by hashtag
SELECT
    t.Tag_name,
    COUNT(DISTINCT pt.Photo_id) AS photos,
    COUNT(DISTINCT l.User_id) AS likes,
    COUNT(DISTINCT c.ID) AS comments,
    COUNT(DISTINCT l.User_id)
        + COUNT(DISTINCT c.ID) AS total_engagement
FROM tags t
JOIN Photo_tags pt
    ON t.ID = pt.Tag_id
LEFT JOIN Likes l
    ON pt.Photo_id = l.Photo_id
LEFT JOIN Comments c
    ON pt.Photo_id = c.Photo_id
GROUP BY t.ID, t.Tag_name
ORDER BY total_engagement DESC;


-- 4. Average engagement per hashtagged photo
SELECT
    t.Tag_name,
    COUNT(DISTINCT pt.Photo_id) AS photos,
    ROUND(
        (
            COUNT(DISTINCT l.User_id)
            + COUNT(DISTINCT c.ID)
        ) * 1.0
        / COUNT(DISTINCT pt.Photo_id),
        2
    ) AS avg_engagement_per_photo
FROM tags t
JOIN Photo_tags pt
    ON t.ID = pt.Tag_id
LEFT JOIN Likes l
    ON pt.Photo_id = l.Photo_id
LEFT JOIN Comments c
    ON pt.Photo_id = c.Photo_id
GROUP BY t.ID, t.Tag_name
ORDER BY avg_engagement_per_photo DESC;


-- 5. Hashtag usage vs engagement
SELECT
    t.Tag_name,
    COUNT(DISTINCT pt.Photo_id) AS usage,
    COUNT(DISTINCT l.User_id)
        + COUNT(DISTINCT c.ID) AS engagement
FROM tags t
JOIN Photo_tags pt
    ON t.ID = pt.Tag_id
LEFT JOIN Likes l
    ON pt.Photo_id = l.Photo_id
LEFT JOIN Comments c
    ON pt.Photo_id = c.Photo_id
GROUP BY t.ID, t.Tag_name
ORDER BY usage DESC;
