USE Instagram;

-- Users
ALTER TABLE Users
    MODIFY COLUMN ID INTEGER AUTO_INCREMENT NOT NULL,
    MODIFY COLUMN User_name VARCHAR(25) NOT NULL,
    MODIFY COLUMN Created_at TIMESTAMP DEFAULT NOW(),
    ADD PRIMARY KEY (ID),
    ADD UNIQUE KEY uq_users_user_name (User_name);

-- Photos
ALTER TABLE Photos
    MODIFY COLUMN ID INTEGER AUTO_INCREMENT NOT NULL,
    MODIFY COLUMN Image_url VARCHAR(255) NOT NULL,
    MODIFY COLUMN User_ID INTEGER NOT NULL,
    MODIFY COLUMN Created_at TIMESTAMP DEFAULT NOW(),
    ADD PRIMARY KEY (ID),
    ADD CONSTRAINT fk_photos_user
        FOREIGN KEY (User_ID) REFERENCES Users(ID);

-- Comments
ALTER TABLE Comments
    MODIFY COLUMN Id INTEGER AUTO_INCREMENT NOT NULL,
    MODIFY COLUMN Comment_text VARCHAR(255) NOT NULL,
    MODIFY COLUMN Photo_id INTEGER NOT NULL,
    MODIFY COLUMN User_id INTEGER NOT NULL,
    MODIFY COLUMN Created_at TIMESTAMP DEFAULT NOW(),
    ADD PRIMARY KEY (Id),
    ADD CONSTRAINT fk_comments_photo
        FOREIGN KEY (Photo_id) REFERENCES Photos(ID),
    ADD CONSTRAINT fk_comments_user
        FOREIGN KEY (User_id) REFERENCES Users(ID);

-- Likes
ALTER TABLE Likes
    MODIFY COLUMN User_id INTEGER NOT NULL,
    MODIFY COLUMN Photo_id INTEGER NOT NULL,
    MODIFY COLUMN Created_at TIMESTAMP DEFAULT NOW(),
    ADD PRIMARY KEY (User_id, Photo_id),
    ADD CONSTRAINT fk_likes_user
        FOREIGN KEY (User_id) REFERENCES Users(ID),
    ADD CONSTRAINT fk_likes_photo
        FOREIGN KEY (Photo_id) REFERENCES Photos(ID);

-- Follows
ALTER TABLE Follows
    MODIFY COLUMN Follower_id INTEGER NOT NULL,
    MODIFY COLUMN Followee_id INTEGER NOT NULL,
    MODIFY COLUMN Created_at TIMESTAMP DEFAULT NOW(),
    ADD PRIMARY KEY (Follower_id, Followee_id),
    ADD CONSTRAINT fk_follows_follower
        FOREIGN KEY (Follower_id) REFERENCES Users(ID),
    ADD CONSTRAINT fk_follows_followee
        FOREIGN KEY (Followee_id) REFERENCES Users(ID);

-- Unfollows
ALTER TABLE Unfollows
    MODIFY COLUMN Follower_id INTEGER NOT NULL,
    MODIFY COLUMN Followee_id INTEGER NOT NULL,
    MODIFY COLUMN Created_at TIMESTAMP DEFAULT NOW(),
    ADD PRIMARY KEY (Follower_id, Followee_id),
    ADD CONSTRAINT fk_unfollows_follower
        FOREIGN KEY (Follower_id) REFERENCES Users(ID),
    ADD CONSTRAINT fk_unfollows_followee
        FOREIGN KEY (Followee_id) REFERENCES Users(ID);

-- Tags
ALTER TABLE Tags
    MODIFY COLUMN ID INTEGER AUTO_INCREMENT NOT NULL,
    MODIFY COLUMN Tag_name VARCHAR(255) NULL,
    MODIFY COLUMN Created_at TIMESTAMP DEFAULT NOW(),
    ADD PRIMARY KEY (ID),
    ADD UNIQUE KEY uq_tags_tag_name (Tag_name);

-- Photo_tags
ALTER TABLE Photo_tags
    MODIFY COLUMN Photo_id INTEGER NOT NULL,
    MODIFY COLUMN Tag_id INTEGER NOT NULL,
    ADD PRIMARY KEY (Photo_id, Tag_id),
    ADD CONSTRAINT fk_photo_tags_photo
        FOREIGN KEY (Photo_id) REFERENCES Photos(ID),
    ADD CONSTRAINT fk_photo_tags_tag
        FOREIGN KEY (Tag_id) REFERENCES Tags(ID);
