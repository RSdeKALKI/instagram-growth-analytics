USE Instagram;

-- Social Network Health

-- 1. Followers and following for every user
SELECT
    Users.ID,
    Users.User_name,
    COALESCE(followers.followers, 0) AS followers,
    COALESCE(following.following, 0) AS following
FROM Users
LEFT JOIN (
    SELECT
        Followee_id,
        COUNT(*) AS followers
    FROM Follows
    GROUP BY Followee_id
) AS followers
    ON Users.ID = followers.Followee_id
LEFT JOIN (
    SELECT
        Follower_id,
        COUNT(*) AS following
    FROM Follows
    GROUP BY Follower_id
) AS following
    ON Users.ID = following.Follower_id
ORDER BY followers DESC;

-- 2. Top 10 users by followers
SELECT
    Users.ID,
    Users.User_name,
    COUNT(Follows.Follower_id) AS followers
FROM Users
LEFT JOIN Follows
    ON Users.ID = Follows.Followee_id
GROUP BY Users.ID, Users.User_name
ORDER BY followers DESC
LIMIT 10;

-- 3. Top 10 users by following
SELECT
    Users.ID,
    Users.User_name,
    COUNT(Follows.Followee_id) AS following
FROM Users
LEFT JOIN Follows
    ON Users.ID = Follows.Follower_id
GROUP BY Users.ID, Users.User_name
ORDER BY following DESC
LIMIT 10;

-- 4. Follower-to-following ratio
SELECT
    Users.ID,
    Users.User_name,
    COALESCE(followers.followers, 0) AS followers,
    COALESCE(following.following, 0) AS following,
    ROUND(
        COALESCE(followers.followers, 0) * 1.0 /
        NULLIF(COALESCE(following.following, 0), 0),
        2
    ) AS follower_following_ratio
FROM Users
LEFT JOIN (
    SELECT Followee_id, COUNT(*) AS followers
    FROM Follows
    GROUP BY Followee_id
) AS followers
    ON Users.ID = followers.Followee_id
LEFT JOIN (
    SELECT Follower_id, COUNT(*) AS following
    FROM Follows
    GROUP BY Follower_id
) AS following
    ON Users.ID = following.Follower_id
ORDER BY follower_following_ratio DESC;

-- 5. Reciprocal follow relationships
SELECT
    f1.Follower_id,
    f1.Followee_id
FROM Follows AS f1
JOIN Follows AS f2
    ON f1.Follower_id = f2.Followee_id
    AND f1.Followee_id = f2.Follower_id
WHERE f1.Follower_id < f1.Followee_id;
