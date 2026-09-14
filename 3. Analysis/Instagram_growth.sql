USE Instagram;

-- 1. How many users registered on the platform?
SELECT COUNT(*) AS total_users
FROM Users;

Result: 100 users.


-- 2. Which year had the highest number of new user registrations?
SELECT
    YEAR(Created_at) AS registration_year,
    COUNT(*) AS new_users
FROM Users
GROUP BY YEAR(Created_at)
ORDER BY new_users DESC;

Results & Insights:

- 2016 had the highest number of new user registrations, with 65 users.
- 2017 had the lowest number of new user registrations, with 35 users.
- User registrations were significantly higher in 2016 than in 2017.
	
-- 3. How is content creation distributed across users?
SELECT
    Users.ID,
    Users.User_name,
    COUNT(Photos.ID) AS total_posts
FROM Users
LEFT JOIN Photos
    ON Users.ID = Photos.User_ID
GROUP BY Users.ID, Users.User_name
ORDER BY total_posts DESC;

Results & Insights:
- Top creators: Eveline95 (12 posts), Clint27 (11 posts) and Cesar93 (10 posts).
- Low contributors: 18 users with only one post.
- Active users: 74 users with atleast one post.
- Inactive users: 26 users with 0 posts.
