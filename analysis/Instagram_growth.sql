USE Instagram;

-- Instagram Growth & User Activation

-- 1. Total registered users
SELECT COUNT(*) AS total_users
FROM Users;

-- 2. User registrations by year
SELECT
    YEAR(Created_at) AS registration_year,
    COUNT(*) AS new_users
FROM Users
GROUP BY YEAR(Created_at)
ORDER BY registration_year;

-- 3. User registrations by month across the full dataset
SELECT
    MONTH(Created_at) AS registration_month,
    MONTHNAME(Created_at) AS month_name,
    COUNT(*) AS new_users
FROM Users
GROUP BY MONTH(Created_at), MONTHNAME(Created_at)
ORDER BY registration_month;

-- 4. Registration day of week
SELECT
    DAYNAME(Created_at) AS registration_day,
    COUNT(*) AS registrations
FROM Users
GROUP BY DAYOFWEEK(Created_at), DAYNAME(Created_at)
ORDER BY registrations DESC;

-- 5. Users who never posted a photo
SELECT
    Users.ID,
    Users.User_name
FROM Users
LEFT JOIN Photos
    ON Users.ID = Photos.User_ID
WHERE Photos.ID IS NULL;

-- 6. Creator / activation rate
SELECT
    COUNT(DISTINCT Photos.User_ID) AS creators,
    COUNT(Users.ID) AS total_users,
    ROUND(
        COUNT(DISTINCT Photos.User_ID) * 100.0 / COUNT(Users.ID),
        2
    ) AS creator_rate_percent
FROM Users
LEFT JOIN Photos
    ON Users.ID = Photos.User_ID;

-- 7. Posts per user
SELECT
    Users.ID,
    Users.User_name,
    COUNT(Photos.ID) AS total_posts
FROM Users
LEFT JOIN Photos
    ON Users.ID = Photos.User_ID
GROUP BY Users.ID, Users.User_name
ORDER BY total_posts DESC;
