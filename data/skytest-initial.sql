CREATE DATABASE IF NOT EXISTS `skytest` CHARACTER SET utf8;
USE `skytest`;
CREATE TABLE IF NOT EXISTS `profile` (
        profile_id  BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
        name        VARCHAR(255) NOT NULL,
        age         INTEGER NOT NULL,
        PRIMARY KEY(profile_id)
    ) CHARACTER SET utf8;
