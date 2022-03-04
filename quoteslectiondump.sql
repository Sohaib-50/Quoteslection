CREATE DATABASE  IF NOT EXISTS `quoteslection` /*!40100 DEFAULT CHARACTER SET latin1 */;
USE `quoteslection`;
-- MySQL dump 10.13  Distrib 8.0.26, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: quoteslection
-- ------------------------------------------------------
-- Server version	5.5.48

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `favourite`
--

DROP TABLE IF EXISTS `favourite`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `favourite` (
  `user_id` int(10) unsigned NOT NULL,
  `quote_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`user_id`,`quote_id`),
  KEY `quote_id` (`quote_id`),
  CONSTRAINT `favourite_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`),
  CONSTRAINT `favourite_ibfk_2` FOREIGN KEY (`quote_id`) REFERENCES `quote` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `favourite`
--

LOCK TABLES `favourite` WRITE;
/*!40000 ALTER TABLE `favourite` DISABLE KEYS */;
INSERT INTO `favourite` VALUES (1,1),(2,1),(3,1),(4,1),(5,1),(1,3),(3,3),(4,3),(5,3),(2,4),(3,5),(1,6),(2,6),(3,6),(4,6),(4,7),(2,10),(4,10),(4,12),(3,14),(4,14),(1,15),(3,17),(1,19),(3,19),(3,21),(1,22),(3,22),(1,27);
/*!40000 ALTER TABLE `favourite` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `quote`
--

DROP TABLE IF EXISTS `quote`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `quote` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `quote_text` varchar(767) NOT NULL,
  `quotee` varchar(50) NOT NULL,
  `submitter_user_id` int(10) unsigned DEFAULT NULL,
  `submission` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `quote_text` (`quote_text`),
  KEY `submitter_user_id` (`submitter_user_id`),
  CONSTRAINT `quote_ibfk_1` FOREIGN KEY (`submitter_user_id`) REFERENCES `user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=29 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `quote`
--

LOCK TABLES `quote` WRITE;
/*!40000 ALTER TABLE `quote` DISABLE KEYS */;
INSERT INTO `quote` VALUES (1,'Hello world','Brogrammer',1,'2021-09-26 11:38:39'),(2,'It always seems impossible untill it\'s done','Nelson Mandela',1,'2021-09-26 11:38:39'),(3,'I have no special talent. I am only passionately curious','Albert Einstein',2,'2021-09-26 11:38:39'),(4,'Twenty years from now you will be more disappointed by the things that you didn’t do than by the ones you did do.','Mark Twain',2,'2021-09-26 11:38:39'),(5,'Those who dare to fail miserably can achieve greatly.','John F. Kennedy',1,'2021-09-26 11:38:39'),(6,'When you have to work, work with a smile.','Kapil Dev',1,'2021-10-01 13:19:27'),(7,'2 + 2 = 4 -1 = 3','Big Shaq',3,'2021-10-02 09:30:31'),(9,'Any fool can write code that a computer can understand. Good programmers write code that humans can understand','Martin Fowler',5,'2021-10-03 05:05:08'),(10,'First, solve the problem. Then, write the code.','John Johnson',5,'2021-10-03 05:05:23'),(11,'Java is to JavaScript what car is to Carpet.','Chris Heilmann',5,'2021-10-03 05:05:34'),(12,'Testing leads to failure, and failure leads to understanding.','Burt Rutan',4,'2021-10-03 05:07:41'),(13,'The best error message is the one that never shows up.','Thomas Fuchs',4,'2021-10-03 05:07:55'),(14,'Tell me and I forget. Teach me and I remember. Involve me and I learn.','Benjamin Franklin',4,'2021-10-03 05:09:48'),(15,'You will face many defeats in life, but never let yourself be defeated.','Maya Angelou',4,'2021-10-03 05:10:08'),(16,'If something\'s important enough, you should try. Even if - the probable outcome is failure.','Elon Musk',2,'2021-10-06 14:12:57'),(17,'People should pursue what they\'re passionate about. That will make them happier than pretty much anything else.','Elon Musk',2,'2021-10-06 14:13:38'),(18,'It is better to keep your mouth closed and let people think you are a fool than to open it and remove all doubt','Mark Twain',2,'2021-10-06 14:14:04'),(19,'Success is the sum of small efforts - repeated day in and day out.','Robert Collier',2,'2021-10-06 14:16:06'),(21,'Rockets are cool. There\'s no getting around that.','Elon Musk',3,'2021-10-06 14:16:59'),(22,'Cheating in school is a form of self-deception. We go to school to learn. We cheat ourselves when we coast on the efforts and scholarship of someone else.','James E. Faust',3,'2021-10-06 14:17:30'),(23,'We are bombarded on all sides by a vast number of messages we don\'t want or need. More information is generated in a single day than we can absorb in a lifetime. To fully enjoy life, all of us must find our own breathing space and peace of mind.','James E. Faust',3,'2021-10-06 14:17:59'),(24,'Today, children are watching more and more television, and are bombarded over and over with images and content that have the potential to dramatically influence their behavior.','Tim Murphy',3,'2021-10-06 14:18:52'),(25,'We make a living by what we get, but we make a life by what we give.','Winston Churchill',1,'2021-10-06 14:20:15'),(27,'If it weren\'t for electricity, we\'d all be watching television by candlelight.','George Gobel',1,'2021-10-06 14:21:24'),(28,'12346','ABC',1,'2021-10-07 04:35:39');
/*!40000 ALTER TABLE `quote` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `username` varchar(30) NOT NULL,
  `firstname` varchar(30) NOT NULL,
  `lastname` varchar(30) DEFAULT NULL,
  `password_hash` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES (1,'Sohaib1','Sohaib','Abbasi','pbkdf2:sha256:260000$1v9Zb2Asld6MC9W5$dc93d404c3cee4fd633e6c9cfbb8471e0884003a4a6cb3645a360b5f2266376a'),(2,'Ali123','Ali','Ahmed','pbkdf2:sha256:260000$1v9Zb2Asld6MC9W5$dc93d404c3cee4fd633e6c9cfbb8471e0884003a4a6cb3645a360b5f2266376a'),(3,'KK123','Kamran','Khan','pbkdf2:sha256:260000$VbYfltWKJXjRXKTD$afb0d7a2a2a73de179aae8ecef38f66133353bf43c7ababf0ee635804723e281'),(4,'SAfridi','Shahid','Afridi','pbkdf2:sha256:260000$rsygHnlw2Um69nzZ$8de831ec955e7b25ded7b7805e7dd63d83dc68ec7a95407231a09e4e76fd9d88'),(5,'SAfridi2','Shahid','','pbkdf2:sha256:260000$RwXF184w6c0BXvwU$68024b80db238eee4ca8fe27747e15a15d7b022a704ab7647e447984a32369ab');
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2022-03-04 18:14:32
