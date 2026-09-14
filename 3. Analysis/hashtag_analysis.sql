USE Instagram;

-- Hashtag & Content Discovery

-- 1. Which hashtags are used most frequently?
SELECT
    Tags.Tag_name,
    COUNT(Photo_tags.Photo_id) AS photos_using_tag
FROM Tags
JOIN Photo_tags
    ON Tags.ID = Photo_tags.Tag_id
GROUP BY Tags.ID, Tags.Tag_name
ORDER BY photos_using_tag DESC;

Results & Insights:
- smile is the most-used hashtag, appearing on 59 photos.
- foodie is the least-used hashtag, appearing on 11 photos.

-- 2. How many different hashtags are used on each photo?
SELECT
    Photos.ID AS photo_id,
    COUNT(Photo_tags.Tag_id) AS number_of_tags
FROM Photos
JOIN Photo_tags
    ON Photos.ID = Photo_tags.Photo_id
GROUP BY Photos.ID
ORDER BY number_of_tags DESC;

Results & Insights:
- 18 photos use 5 hastags for a single post where as 47 photos use only 1 hashtag.
