-- creates database and tables, and adds some data

-- Todo: create indexes
-- @block
CREATE DATABASE IF NOT EXISTS quoteslection;

-- @block
CREATE TABLE user (
id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
username VARCHAR(30) UNIQUE NOT NULL,
firstname VARCHAR(30) NOT NULL,
lastname VARCHAR(30),
password_hash VARCHAR(255) NOT NULL
);

-- @block
CREATE TABLE quote (
id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
quote_text VARCHAR(767) UNIQUE NOT NULL,  -- same quote cant be submitted more than once to avoid spam and clutter
quotee VARCHAR(50) NOT NULL,
submitter_user_id INT UNSIGNED,
submission TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
FOREIGN KEY (submitter_user_id) REFERENCES user(id)
);

-- @block
CREATE TABLE favourite (
user_id INT UNSIGNED NOT NULL,
quote_id INT UNSIGNED NOT NULL,
PRIMARY KEY(user_id, quote_id),
FOREIGN KEY(user_id) REFERENCES user(id),
FOREIGN KEY(quote_id) REFERENCES quote(id)
);

-- @block
-- INSERT INTO user (username, firstname, lastname, password_hash)
-- VALUES 
--     ("Sohaib1", "Sohaib", "Abbasi", "pbkdf2:sha256:260000$1v9Zb2Asld6MC9W5$dc93d404c3cee4fd633e6c9cfbb8471e0884003a4a6cb3645a360b5f2266376a"),
--     ("Ali123", "Ali", "Ahmed", "pbkdf2:sha256:260000$1v9Zb2Asld6MC9W5$dc93d404c3cee4fd633e6c9cfbb8471e0884003a4a6cb3645a360b5f2266376a");

-- -- @BLOCK
-- INSERT INTO quote (quote_text, quotee, submitter_user_id) VALUES ("Hello world", "Brogrammer", 1);
-- INSERT INTO quote (quote_text, quotee, submitter_user_id) VALUES ("It always seems impossible untill it's done", "Nelson Mandela", 1);
-- INSERT INTO quote (quote_text, quotee, submitter_user_id) VALUES ("I have no special talent. I am only passionately curious", "Albert Einstein", 2);
-- INSERT INTO quote (quote_text, quotee, submitter_user_id) VALUES ("Twenty years from now you will be more disappointed by the things that you didn’t do than by the ones you did do.", "Mark Twain", 2);
-- INSERT INTO quote (quote_text, quotee, submitter_user_id) VALUES ("Those who dare to fail miserably can achieve greatly.", "John F. Kennedy", 1);
