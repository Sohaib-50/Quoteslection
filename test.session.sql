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
CREATE TABLE quotes (
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


-- @BLOCK
INSERT INTO  quotes (quote_text, quotee, user_id) VALUES ("Hello world", "Brogrammer", 1);

-- @BLOCK
INSERT INTO quotes (quote_text, quotee, user_id) VALUES ("It always seems impossible untill it's done", "Nelson Mandela", 1);
INSERT INTO quotes (quote_text, quotee, user_id) VALUES ("I have no special talent. I am only passionately curious", "Albert Einstein", 10);
INSERT INTO quotes (quote_text, quotee, user_id) VALUES ("Twenty years from now you will be more disappointed by the things that you didn’t do than by the ones you did do.", "Mark Twain", 1);
INSERT INTO quotes (quote_text, quotee, user_id) VALUES ("Those who dare to fail miserably can achieve greatly.", "John F. Kennedy", 1);


--@block
UPDATE users
SET firstname = 'Test1', lastname = 'User'
WHERE username = 'SA55';


-- @block
CREATE TABLE favourites (
user_id INT UNSIGNED,
quote_id INT UNSIGNED,
PRIMARY KEY(user_id, quote_id),
FOREIGN KEY(user_id) REFERENCES users(id),
FOREIGN KEY(quote_id) REFERENCES quotes(id)
);

--@block
DELETE FROM favourites;
