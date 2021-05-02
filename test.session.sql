-- @block
CREATE DATABASE IF NOT EXISTS quoteslection;

-- @block
CREATE TABLE users (
id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
username VARCHAR(20) UNIQUE NOT NULL,
firstname VARCHAR(30) NOT NULL,
lastname VARCHAR(30) NOT NULL,
pass VARCHAR(255) NOT NULL
);


-- @block
CREATE TABLE quotes2 (
id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
quote_text VARCHAR(510) UNIQUE NOT NULL,
quotee VARCHAR(50) NOT NULL,
user_id INT UNSIGNED,
submission TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
FOREIGN KEY (user_id) REFERENCES users(id)
);

-- @block
INSERT INTO users (username, firstname, lastname, pass)
VALUES ("SA51", "Sohaib", "Abbasi", "Hello");
INSERT INTO users (username, firstname, lastname, pass)
VALUES ("SA52", "Sohaib", "Abbasi", "Hello");
INSERT INTO users (username, firstname, lastname, pass)
VALUES ("SA53", "Sohaib", "Abbasi", "Hello");

-- @BLOCK
DELETE FROM users WHERE username = "SA52";


-- @BLOCK
INSERT INTO users (username, firstname, lastname, pass)
VALUES ("SA54", "Sohaib", "Abbasi", "Hello");

-- @block
INSERT INTO users (username, firstname, lastname, pass)
VALUES ("SA55", "Sohaib", "Abbasi", "Hello");
