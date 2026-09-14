USE instagram;

-- =====================================================
-- SOCIAL NETWORK HEALTH
-- =====================================================

-- 1. Followers and following for every user
SELECT
    u.ID,
    u.User_name,
    COUNT(DISTINCT followers.Follower_id) AS followers,
    COUNT(DISTINCT following.Followee_id) AS following
FROM Users u
LEFT JOIN Follows followers
    ON u.ID = followers.Followee_id
LEFT JOIN Follows following
    ON u.ID = following.Follower_id
GROUP BY u.ID, u.User_name
ORDER BY followers DESC;


-- 2. Users with the largest follower counts
SELECT
    u.ID,
    u.User_name,
    COUNT(f.Follower_id) AS followers
FROM Users u
LEFT JOIN Follows f
    ON u.ID = f.Followee_id
GROUP BY u.ID, u.User_name
ORDER BY followers DESC
LIMIT 10;


-- 3. Users following the most accounts
SELECT
    u.ID,
    u.User_name,
    COUNT(f.Followee_id) AS following
FROM Users u
LEFT JOIN Follows f
    ON u.ID = f.Follower_id
GROUP BY u.ID, u.User_name
ORDER BY following DESC
LIMIT 10;


-- 4. Follower / following ratio
SELECT
    u.ID,
    u.User_name,
    COUNT(DISTINCT followers.Follower_id) AS followers,
    COUNT(DISTINCT following.Followee_id) AS following,
    ROUND(
        COUNT(DISTINCT followers.Follower_id) * 1.0 /
        NULLIF(COUNT(DISTINCT following.Followee_id), 0),
        2
    ) AS follower_following_ratio
FROM Users u
LEFT JOIN Follows followers
    ON u.ID = followers.Followee_id
LEFT JOIN Follows following
    ON u.ID = following.Follower_id
GROUP BY u.ID, u.User_name
ORDER BY follower_following_ratio DESC;


-- 5. Reciprocal relationships
SELECT
    f1.Follower_id,
    f1.Followee_id
FROM Follows f1
JOIN Follows f2
    ON f1.Follower_id = f2.Followee_id
    AND f1.Followee_id = f2.Follower_id
WHERE f1.Follower_id < f1.Followee_id;


-- 6. Number of reciprocal relationships
SELECT
    COUNT(*) AS reciprocal_relationships
FROM Follows f1
JOIN Follows f2
    ON f1.Follower_id = f2.Followee_id
    AND f1.Followee_id = f2.Follower_id
WHERE f1.Follower_id < f1.Followee_id;


-- 7. Follow activity by month
SELECT
    YEAR(Created_at) AS year,
    MONTH(Created_at) AS month,
    COUNT(*) AS follows_created
FROM Follows
GROUP BY YEAR(Created_at), MONTH(Created_at)
ORDER BY year, month;


-- 8. Unfollow activity by month
SELECT
    YEAR(Created_at) AS year,
    MONTH(Created_at) AS month,
    COUNT(*) AS unfollows
FROM Unfollows
GROUP BY YEAR(Created_at), MONTH(Created_at)
ORDER BY year, month;


-- 9. Follow vs unfollow activity
SELECT
    (
        SELECT COUNT(*)
        FROM Follows
    ) AS total_follows,
    (
        SELECT COUNT(*)
        FROM Unfollows
    ) AS total_unfollows;
