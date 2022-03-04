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
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2022-03-04 18:14:44
