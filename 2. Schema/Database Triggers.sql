-- Prevents users from following their own account.

DELIMITER $$

CREATE TRIGGER example_cannot_follow_self
BEFORE INSERT ON Follows
FOR EACH ROW
BEGIN
    IF NEW.Follower_id = NEW.Followee_id
    THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Cannot follow yourself, silly';
    END IF;
END$$

DELIMITER ;


-- Automatically records a deleted follow relationship in the Unfollows table.

DELIMITER $$

CREATE TRIGGER create_unfollow
AFTER DELETE ON Follows
FOR EACH ROW
BEGIN
    INSERT INTO Unfollows
    SET Follower_id = OLD.Follower_id,
        Followee_id = OLD.Followee_id;
END$$

DELIMITER ;
