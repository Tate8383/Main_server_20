-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Server version:               10.4.17-MariaDB - mariadb.org binary distribution
-- Server OS:                    Win64
-- HeidiSQL Version:             11.2.0.6213
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


-- Dumping database structure for denalifwstd
CREATE DATABASE IF NOT EXISTS `denalifwstd` /*!40100 DEFAULT CHARACTER SET utf8 */;
USE `denalifwstd`;

-- Dumping structure for table denalifwstd.apartments
CREATE TABLE IF NOT EXISTS `apartments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `type` varchar(255) DEFAULT NULL,
  `label` varchar(255) DEFAULT NULL,
  `citizenid` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `citizenid` (`citizenid`),
  KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;

-- Dumping data for table denalifwstd.apartments: ~5 rows (approximately)
/*!40000 ALTER TABLE `apartments` DISABLE KEYS */;
INSERT INTO `apartments` (`id`, `name`, `type`, `label`, `citizenid`) VALUES
	(1, 'apartment51731', 'apartment5', 'Fantastic Plaza 1731', 'FZA36239'),
	(2, 'apartment51659', 'apartment5', 'Fantastic Plaza 1659', 'QIK97947'),
	(3, 'apartment29424', 'apartment2', 'Morningwood Blvd 9424', 'UXN47399'),
	(4, 'apartment53040', 'apartment5', 'Fantastic Plaza 3040', 'SWX89939'),
	(5, 'apartment34497', 'apartment3', 'Integrity Way 4497', 'XXN37548');
/*!40000 ALTER TABLE `apartments` ENABLE KEYS */;

-- Dumping structure for table denalifwstd.bank_accounts
CREATE TABLE IF NOT EXISTS `bank_accounts` (
  `record_id` bigint(255) NOT NULL AUTO_INCREMENT,
  `citizenid` varchar(250) DEFAULT NULL,
  `business` varchar(50) DEFAULT NULL,
  `businessid` int(11) DEFAULT NULL,
  `gangid` varchar(50) DEFAULT NULL,
  `amount` bigint(255) NOT NULL DEFAULT 0,
  `account_type` enum('Current','Savings','Business','Gang') NOT NULL DEFAULT 'Current',
  PRIMARY KEY (`record_id`),
  UNIQUE KEY `citizenid` (`citizenid`),
  KEY `business` (`business`),
  KEY `businessid` (`businessid`),
  KEY `gangid` (`gangid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table denalifwstd.bank_accounts: ~0 rows (approximately)
/*!40000 ALTER TABLE `bank_accounts` DISABLE KEYS */;
/*!40000 ALTER TABLE `bank_accounts` ENABLE KEYS */;

-- Dumping structure for table denalifwstd.bank_statements
CREATE TABLE IF NOT EXISTS `bank_statements` (
  `record_id` bigint(255) NOT NULL AUTO_INCREMENT,
  `citizenid` varchar(50) DEFAULT NULL,
  `account` varchar(50) DEFAULT NULL,
  `business` varchar(50) DEFAULT NULL,
  `businessid` int(11) DEFAULT NULL,
  `gangid` varchar(50) DEFAULT NULL,
  `deposited` int(11) DEFAULT NULL,
  `withdraw` int(11) DEFAULT NULL,
  `balance` int(11) DEFAULT NULL,
  `date` varchar(50) DEFAULT NULL,
  `type` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`record_id`),
  KEY `business` (`business`),
  KEY `businessid` (`businessid`),
  KEY `gangid` (`gangid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table denalifwstd.bank_statements: ~0 rows (approximately)
/*!40000 ALTER TABLE `bank_statements` DISABLE KEYS */;
/*!40000 ALTER TABLE `bank_statements` ENABLE KEYS */;

-- Dumping structure for table denalifwstd.bans
CREATE TABLE IF NOT EXISTS `bans` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) DEFAULT NULL,
  `license` varchar(50) DEFAULT NULL,
  `discord` varchar(50) DEFAULT NULL,
  `ip` varchar(50) DEFAULT NULL,
  `reason` text DEFAULT NULL,
  `expire` int(11) DEFAULT NULL,
  `bannedby` varchar(255) NOT NULL DEFAULT 'LeBanhammer',
  PRIMARY KEY (`id`),
  KEY `license` (`license`),
  KEY `discord` (`discord`),
  KEY `ip` (`ip`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table denalifwstd.bans: ~0 rows (approximately)
/*!40000 ALTER TABLE `bans` DISABLE KEYS */;
/*!40000 ALTER TABLE `bans` ENABLE KEYS */;

-- Dumping structure for table denalifwstd.crypto
CREATE TABLE IF NOT EXISTS `crypto` (
  `crypto` varchar(50) NOT NULL DEFAULT 'qbit',
  `worth` int(11) NOT NULL DEFAULT 0,
  `history` text DEFAULT NULL,
  PRIMARY KEY (`crypto`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table denalifwstd.crypto: ~1 rows (approximately)
/*!40000 ALTER TABLE `crypto` DISABLE KEYS */;
INSERT INTO `crypto` (`crypto`, `worth`, `history`) VALUES
	('qbit', 55, '[{"NewWorth":55,"PreviousWorth":55},{"NewWorth":1,"PreviousWorth":1},{"NewWorth":1,"PreviousWorth":1},{"NewWorth":1,"PreviousWorth":1}]');
/*!40000 ALTER TABLE `crypto` ENABLE KEYS */;

-- Dumping structure for table denalifwstd.crypto_transactions
CREATE TABLE IF NOT EXISTS `crypto_transactions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `citizenid` varchar(50) DEFAULT NULL,
  `title` varchar(50) DEFAULT NULL,
  `message` varchar(50) DEFAULT NULL,
  `date` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `citizenid` (`citizenid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table denalifwstd.crypto_transactions: ~0 rows (approximately)
/*!40000 ALTER TABLE `crypto_transactions` DISABLE KEYS */;
/*!40000 ALTER TABLE `crypto_transactions` ENABLE KEYS */;

-- Dumping structure for table denalifwstd.dealers
CREATE TABLE IF NOT EXISTS `dealers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL DEFAULT '0',
  `coords` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `time` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `createdby` varchar(50) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table denalifwstd.dealers: ~0 rows (approximately)
/*!40000 ALTER TABLE `dealers` DISABLE KEYS */;
/*!40000 ALTER TABLE `dealers` ENABLE KEYS */;

-- Dumping structure for table denalifwstd.gloveboxitems
CREATE TABLE IF NOT EXISTS `gloveboxitems` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `plate` varchar(255) NOT NULL DEFAULT '[]',
  `items` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  PRIMARY KEY (`plate`),
  KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table denalifwstd.gloveboxitems: ~0 rows (approximately)
/*!40000 ALTER TABLE `gloveboxitems` DISABLE KEYS */;
/*!40000 ALTER TABLE `gloveboxitems` ENABLE KEYS */;

-- Dumping structure for table denalifwstd.houselocations
CREATE TABLE IF NOT EXISTS `houselocations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `label` varchar(255) DEFAULT NULL,
  `coords` text DEFAULT NULL,
  `owned` tinyint(1) DEFAULT NULL,
  `price` int(11) DEFAULT NULL,
  `tier` tinyint(4) DEFAULT NULL,
  `garage` text DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

-- Dumping data for table denalifwstd.houselocations: ~1 rows (approximately)
/*!40000 ALTER TABLE `houselocations` DISABLE KEYS */;
INSERT INTO `houselocations` (`id`, `name`, `label`, `coords`, `owned`, `price`, `tier`, `garage`) VALUES
	(1, 'olympic fwy1', 'Olympic Fwy 1', '{"enter":{"y":-1213.06396484375,"z":28.66036415100097,"x":-53.81039047241211,"h":323.3861083984375},"cam":{"y":-1213.06396484375,"z":28.66036415100097,"x":-53.81039047241211,"h":323.3861083984375,"yaw":-10.0}}', 1, 1, 1, NULL);
/*!40000 ALTER TABLE `houselocations` ENABLE KEYS */;

-- Dumping structure for table denalifwstd.house_plants
CREATE TABLE IF NOT EXISTS `house_plants` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `building` varchar(50) DEFAULT NULL,
  `stage` varchar(50) DEFAULT 'stage-a',
  `sort` varchar(50) DEFAULT NULL,
  `gender` varchar(50) DEFAULT NULL,
  `food` int(11) DEFAULT 100,
  `health` int(11) DEFAULT 100,
  `progress` int(11) DEFAULT 0,
  `coords` text DEFAULT NULL,
  `plantid` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `building` (`building`),
  KEY `plantid` (`plantid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table denalifwstd.house_plants: ~0 rows (approximately)
/*!40000 ALTER TABLE `house_plants` DISABLE KEYS */;
/*!40000 ALTER TABLE `house_plants` ENABLE KEYS */;

-- Dumping structure for table denalifwstd.lapraces
CREATE TABLE IF NOT EXISTS `lapraces` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) DEFAULT NULL,
  `checkpoints` text DEFAULT NULL,
  `records` text DEFAULT NULL,
  `creator` varchar(50) DEFAULT NULL,
  `distance` int(11) DEFAULT NULL,
  `raceid` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `raceid` (`raceid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table denalifwstd.lapraces: ~0 rows (approximately)
/*!40000 ALTER TABLE `lapraces` DISABLE KEYS */;
/*!40000 ALTER TABLE `lapraces` ENABLE KEYS */;

-- Dumping structure for table denalifwstd.occasion_vehicles
CREATE TABLE IF NOT EXISTS `occasion_vehicles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `seller` varchar(50) DEFAULT NULL,
  `price` int(11) DEFAULT NULL,
  `description` longtext DEFAULT NULL,
  `plate` varchar(50) DEFAULT NULL,
  `model` varchar(50) DEFAULT NULL,
  `mods` text DEFAULT NULL,
  `occasionid` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `occasionId` (`occasionid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table denalifwstd.occasion_vehicles: ~0 rows (approximately)
/*!40000 ALTER TABLE `occasion_vehicles` DISABLE KEYS */;
/*!40000 ALTER TABLE `occasion_vehicles` ENABLE KEYS */;

-- Dumping structure for table denalifwstd.permissions
CREATE TABLE IF NOT EXISTS `permissions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `license` varchar(255) NOT NULL,
  `permission` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `license` (`license`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table denalifwstd.permissions: ~0 rows (approximately)
/*!40000 ALTER TABLE `permissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `permissions` ENABLE KEYS */;

-- Dumping structure for table denalifwstd.phone_gallery
CREATE TABLE IF NOT EXISTS `phone_gallery` (
  `citizenid` varchar(255) NOT NULL,
  `image` varchar(255) NOT NULL,
  `date` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Dumping data for table denalifwstd.phone_gallery: ~0 rows (approximately)
/*!40000 ALTER TABLE `phone_gallery` DISABLE KEYS */;
/*!40000 ALTER TABLE `phone_gallery` ENABLE KEYS */;

-- Dumping structure for table denalifwstd.phone_invoices
CREATE TABLE IF NOT EXISTS `phone_invoices` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `citizenid` varchar(50) DEFAULT NULL,
  `amount` int(11) NOT NULL DEFAULT 0,
  `society` tinytext DEFAULT NULL,
  `sender` varchar(50) DEFAULT NULL,
  `sendercitizenid` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `citizenid` (`citizenid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table denalifwstd.phone_invoices: ~0 rows (approximately)
/*!40000 ALTER TABLE `phone_invoices` DISABLE KEYS */;
/*!40000 ALTER TABLE `phone_invoices` ENABLE KEYS */;

-- Dumping structure for table denalifwstd.phone_messages
CREATE TABLE IF NOT EXISTS `phone_messages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `citizenid` varchar(50) DEFAULT NULL,
  `number` varchar(50) DEFAULT NULL,
  `messages` text DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `citizenid` (`citizenid`),
  KEY `number` (`number`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table denalifwstd.phone_messages: ~0 rows (approximately)
/*!40000 ALTER TABLE `phone_messages` DISABLE KEYS */;
/*!40000 ALTER TABLE `phone_messages` ENABLE KEYS */;

-- Dumping structure for table denalifwstd.phone_tweets
CREATE TABLE IF NOT EXISTS `phone_tweets` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `citizenid` varchar(50) DEFAULT NULL,
  `firstName` varchar(25) DEFAULT NULL,
  `lastName` varchar(25) DEFAULT NULL,
  `message` text DEFAULT NULL,
  `date` datetime DEFAULT current_timestamp(),
  `url` text DEFAULT NULL,
  `picture` varchar(512) DEFAULT './img/default.png',
  `tweetId` varchar(25) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `citizenid` (`citizenid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table denalifwstd.phone_tweets: ~0 rows (approximately)
/*!40000 ALTER TABLE `phone_tweets` DISABLE KEYS */;
/*!40000 ALTER TABLE `phone_tweets` ENABLE KEYS */;

-- Dumping structure for table denalifwstd.players
CREATE TABLE IF NOT EXISTS `players` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `citizenid` varchar(50) NOT NULL,
  `cid` int(11) DEFAULT NULL,
  `license` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `money` text NOT NULL,
  `charinfo` text DEFAULT NULL,
  `job` text NOT NULL,
  `gang` text DEFAULT NULL,
  `position` text NOT NULL,
  `metadata` text NOT NULL,
  `inventory` longtext DEFAULT NULL,
  `last_updated` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`citizenid`),
  KEY `id` (`id`),
  KEY `last_updated` (`last_updated`),
  KEY `license` (`license`)
) ENGINE=InnoDB AUTO_INCREMENT=59 DEFAULT CHARSET=utf8;

-- Dumping data for table denalifwstd.players: ~5 rows (approximately)
/*!40000 ALTER TABLE `players` DISABLE KEYS */;
INSERT INTO `players` (`id`, `citizenid`, `cid`, `license`, `name`, `money`, `charinfo`, `job`, `gang`, `position`, `metadata`, `inventory`, `last_updated`) VALUES
	(1, 'FZA36239', 1, 'license:3de8fa5314866ffce7a517e626d26ef6d0676264', 'deakum', '{"bank":6050,"crypto":0,"cash":500}', '{"nationality":"American","phone":"1142918125","account":"US08DenaliFW4687830172","firstname":"Jane","backstory":"placeholder backstory","lastname":"Doe","birthdate":"1999-12-12","gender":0,"cid":"1"}', '{"isboss":true,"name":"police","payment":150,"onduty":true,"label":"Law Enforcement","grade":{"level":4,"name":"Chief"}}', '{"isboss":false,"name":"none","label":"No Gang Affiliaton","grade":{"level":0,"name":"none"}}', '{"x":25.13406753540039,"y":-739.95166015625,"z":31.6724853515625}', '{"inside":{"apartment":[]},"hunger":11.79999999999995,"attachmentcraftingrep":0,"walletid":"denalifw-84056180","fitbit":[],"dealerrep":0,"inlaststand":false,"ishandcuffed":false,"fingerprint":"Cb424r90eIp8822","callsign":"NO CALLSIGN","thirst":20.20000000000004,"isdead":false,"phonedata":{"SerialNumber":40588084,"InstalledApps":[]},"craftingrep":0,"tracker":false,"stress":0,"commandbinds":[],"criminalrecord":{"hasRecord":false},"currentapartment":"apartment51731","injail":0,"bloodtype":"A+","status":[],"licences":{"weapon":false,"driver":true,"business":false},"armor":0,"phone":[],"jailitems":[],"jobrep":{"taxi":0,"trucker":0,"tow":0,"hotdog":0}}', '[{"amount":1,"name":"driver_license","slot":1,"info":{"lastname":"Doe","birthdate":"1999-12-12","firstname":"Jane","type":"Class C Driver License"},"type":"item"},{"amount":1,"name":"phone","slot":2,"info":[],"type":"item"},{"amount":1,"name":"id_card","slot":3,"info":{"firstname":"Jane","gender":0,"lastname":"Doe","nationality":"American","citizenid":"FZA36239","birthdate":"1999-12-12"},"type":"item"}]', '2022-02-04 09:10:56'),
	(22, 'QIK97947', 1, 'license:30039eb26a70084d60becacf0762f452d8d19498', 'deakum', '{"crypto":0,"cash":500,"bank":5010}', '{"account":"US07DenaliFW9372908888","backstory":"placeholder backstory","firstname":"Samual","cid":"1","nationality":"Test","phone":"1313657058","gender":0,"birthdate":"1999-11-11","lastname":"JJ"}', '{"label":"Civilian","grade":{"name":"Freelancer","level":0},"onduty":true,"isboss":false,"name":"unemployed","payment":10}', '{"label":"No Gang Affiliaton","isboss":false,"name":"none","grade":{"name":"none","level":0}}', '{"x":229.7010955810547,"y":-1122.5142822265626,"z":29.229248046875}', '{"criminalrecord":{"hasRecord":false},"inlaststand":false,"thirst":100,"injail":0,"isdead":false,"status":[],"dealerrep":0,"currentapartment":"apartment51659","phonedata":{"SerialNumber":48783944,"InstalledApps":[]},"fitbit":[],"inside":{"apartment":{"apartmentType":"apartment5","apartmentId":"apartment51659"}},"licences":{"weapon":false,"driver":true,"business":false},"walletid":"denalifw-37961215","attachmentcraftingrep":0,"fingerprint":"PO922w41Lvp7127","armor":0,"stress":0,"hunger":100,"phone":[],"commandbinds":[],"jobrep":{"tow":0,"hotdog":0,"taxi":0,"trucker":0},"tracker":false,"craftingrep":0,"bloodtype":"A-","ishandcuffed":false,"jailitems":[],"callsign":"NO CALLSIGN"}', '[{"name":"driver_license","slot":1,"info":{"firstname":"Samual","birthdate":"1999-11-11","type":"Class C Driver License","lastname":"JJ"},"type":"item","amount":1},{"name":"id_card","slot":2,"info":{"birthdate":"1999-11-11","lastname":"JJ","firstname":"Samual","citizenid":"QIK97947","gender":0,"nationality":"Test"},"type":"item","amount":1},{"name":"phone","slot":3,"info":[],"type":"item","amount":1}]', '2022-02-01 13:53:13'),
	(38, 'SWX89939', 3, 'license:3de8fa5314866ffce7a517e626d26ef6d0676264', 'deakum', '{"crypto":0,"bank":838,"cash":150}', '{"nationality":"Native","firstname":"Admin","phone":"1418790549","birthdate":"1999-11-11","card":5751798429796240,"backstory":"placeholder backstory","cid":"3","lastname":"Testing","gender":0,"account":"US08DenaliFW4282335099"}', '{"name":"police","isboss":false,"label":"Law Enforcement","payment":125,"grade":{"name":"Lieutenant","level":3},"onduty":false}', '{"name":"none","grade":{"name":"none","level":0},"label":"No Gang Affiliaton","isboss":false}', '{"x":275.6175842285156,"y":-605.103271484375,"z":42.9619140625}', '{"fingerprint":"xT401K55dpj0143","currentapartment":"apartment53040","phone":{"background":"https://wallpapercave.com/wp/j8zQnGA.jpg","profilepicture":"default"},"bloodtype":"B+","walletid":"denalifw-53057086","injail":0,"attachmentcraftingrep":0,"ishandcuffed":false,"inlaststand":false,"stress":0,"fitbit":[],"callsign":"NO CALLSIGN","tracker":false,"phonedata":{"InstalledApps":[],"SerialNumber":60924286},"inside":{"apartment":[]},"status":[],"licences":{"business":false,"driver":true,"weapon":false},"jailitems":[],"dealerrep":0,"criminalrecord":{"hasRecord":false},"armor":0,"craftingrep":0,"commandbinds":[],"thirst":96.2,"jobrep":{"trucker":0,"tow":0,"hotdog":0,"taxi":0},"isdead":false,"hunger":95.8}', '[{"name":"id_card","amount":1,"type":"item","info":{"citizenid":"SWX89939","firstname":"Admin","gender":0,"lastname":"Testing","birthdate":"1999-11-11","nationality":"Native"},"slot":1},{"name":"driver_license","amount":1,"type":"item","info":{"birthdate":"1999-11-11","lastname":"Testing","firstname":"Admin","type":"Class C Driver License"},"slot":2},{"name":"phone","amount":1,"type":"item","info":[],"slot":3},{"name":"visa","amount":1,"type":"item","info":{"name":"Admin Testing","cardPin":1111,"cardNumber":5751798429796240,"cardType":"visa","citizenid":"SWX89939","cardActive":true},"slot":4},{"name":"advancedlockpick","amount":1,"type":"item","info":[],"slot":5}]', '2022-02-02 15:36:44'),
	(36, 'UXN47399', 2, 'license:3de8fa5314866ffce7a517e626d26ef6d0676264', 'deakum', '{"crypto":0,"cash":500,"bank":5000}', '{"cid":"2","gender":0,"account":"US03DenaliFW3981942985","nationality":"Saddd","phone":"1899931474","lastname":"Anon","firstname":"Zswww","birthdate":"1999-12-21","backstory":"placeholder backstory"}', '{"grade":{"name":"Freelancer","level":0},"onduty":true,"isboss":false,"name":"unemployed","payment":10,"label":"Civilian"}', '{"name":"none","grade":{"name":"none","level":0},"isboss":false,"label":"No Gang Affiliaton"}', '{"x":-350.3736267089844,"y":-48.42197799682617,"z":49.02783203125}', '{"criminalrecord":{"hasRecord":false},"walletid":"denalifw-94929081","inlaststand":false,"attachmentcraftingrep":0,"ishandcuffed":false,"fingerprint":"jm949u91Hyn5675","injail":0,"dealerrep":0,"craftingrep":0,"fitbit":[],"callsign":"NO CALLSIGN","licences":{"business":false,"driver":true,"weapon":false},"thirst":100,"inside":{"apartment":[]},"commandbinds":[],"hunger":100,"status":[],"isdead":false,"currentapartment":"apartment29424","tracker":false,"jailitems":[],"jobrep":{"tow":0,"trucker":0,"taxi":0,"hotdog":0},"phone":{"background":"https://wallpapercave.com/wp/6gqwPWH.jpg","profilepicture":"default"},"armor":0,"stress":0,"phonedata":{"InstalledApps":[],"SerialNumber":86926333},"bloodtype":"B-"}', '[{"info":{"firstname":"Zswww","lastname":"Anon","birthdate":"1999-12-21","type":"Class C Driver License"},"name":"driver_license","slot":1,"type":"item","amount":1},{"info":{"citizenid":"UXN47399","lastname":"Anon","firstname":"Zswww","nationality":"Saddd","birthdate":"1999-12-21","gender":0},"name":"id_card","slot":2,"type":"item","amount":1},{"info":[],"name":"phone","slot":3,"type":"item","amount":1}]', '2022-02-02 14:52:36'),
	(45, 'XXN37548', 1, 'license:c2f23a5decf3038ccce4118400046164eae92c49', 'Seiko', '{"crypto":0,"bank":5000,"cash":500}', '{"gender":0,"firstname":"Sergio","phone":"1938843339","birthdate":"1991-11-25","cid":"1","nationality":"Italian","lastname":"Marquinas","backstory":"placeholder backstory","account":"US08DenaliFW5747368763"}', '{"name":"unemployed","isboss":false,"label":"Civilian","payment":10,"grade":{"name":"Freelancer","level":0},"onduty":true}', '{"name":"none","grade":{"name":"none","level":0},"label":"No Gang Affiliaton","isboss":false}', '{"x":198.962646484375,"y":-930.0263671875,"z":30.6783447265625}', '{"fingerprint":"kJ596C80GHt2049","currentapartment":"apartment34497","phone":{"profilepicture":"","background":""},"bloodtype":"AB-","walletid":"denalifw-26027854","injail":0,"attachmentcraftingrep":0,"ishandcuffed":false,"phonedata":{"InstalledApps":[],"SerialNumber":52630050},"stress":0,"fitbit":[],"callsign":"NO CALLSIGN","tracker":false,"inside":{"apartment":[]},"inlaststand":false,"status":[],"licences":{"business":false,"driver":true,"weapon":false},"jailitems":[],"isdead":false,"criminalrecord":{"hasRecord":false},"armor":0,"craftingrep":0,"commandbinds":[],"thirst":100,"jobrep":{"trucker":0,"tow":0,"hotdog":0,"taxi":0},"dealerrep":0,"hunger":100}', '[{"name":"id_card","amount":1,"type":"item","info":{"citizenid":"XXN37548","firstname":"Sergio","gender":0,"lastname":"Marquinas","birthdate":"1991-11-25","nationality":"Italian"},"slot":1},{"name":"driver_license","amount":1,"type":"item","info":{"birthdate":"1991-11-25","lastname":"Marquinas","firstname":"Sergio","type":"Class C Driver License"},"slot":2},{"name":"phone","amount":1,"type":"item","info":[],"slot":3}]', '2022-02-03 20:10:41');
/*!40000 ALTER TABLE `players` ENABLE KEYS */;

-- Dumping structure for table denalifwstd.playerskins
CREATE TABLE IF NOT EXISTS `playerskins` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `citizenid` varchar(255) NOT NULL,
  `model` varchar(255) NOT NULL,
  `skin` text NOT NULL,
  `active` tinyint(4) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  KEY `citizenid` (`citizenid`),
  KEY `active` (`active`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;

-- Dumping data for table denalifwstd.playerskins: ~4 rows (approximately)
/*!40000 ALTER TABLE `playerskins` DISABLE KEYS */;
INSERT INTO `playerskins` (`id`, `citizenid`, `model`, `skin`, `active`) VALUES
	(1, 'FZA36239', '1885233650', '{"nose_4":{"item":0,"defaultTexture":0,"texture":0,"defaultItem":0},"glass":{"item":0,"defaultTexture":0,"texture":0,"defaultItem":0},"eyebrown_forward":{"item":0,"defaultTexture":0,"texture":0,"defaultItem":0},"chimp_bone_lenght":{"item":0,"defaultTexture":0,"texture":0,"defaultItem":0},"beard":{"item":-1,"defaultTexture":1,"texture":1,"defaultItem":-1},"torso2":{"item":26,"defaultTexture":0,"texture":0,"defaultItem":0},"shoes":{"item":8,"defaultTexture":0,"texture":0,"defaultItem":1},"arms":{"item":0,"defaultTexture":0,"texture":0,"defaultItem":0},"accessory":{"item":0,"defaultTexture":0,"texture":0,"defaultItem":0},"bag":{"item":0,"defaultTexture":0,"texture":0,"defaultItem":0},"nose_0":{"item":0,"defaultTexture":0,"texture":0,"defaultItem":0},"jaw_bone_back_lenght":{"item":0,"defaultTexture":0,"texture":0,"defaultItem":0},"neck_thikness":{"item":0,"defaultTexture":0,"texture":0,"defaultItem":0},"cheek_3":{"item":0,"defaultTexture":0,"texture":0,"defaultItem":0},"nose_3":{"item":0,"defaultTexture":0,"texture":0,"defaultItem":0},"moles":{"item":-1,"defaultTexture":0,"texture":0,"defaultItem":-1},"hair":{"item":0,"defaultTexture":0,"texture":0,"defaultItem":0},"ageing":{"item":-1,"defaultTexture":0,"texture":0,"defaultItem":-1},"blush":{"item":-1,"defaultTexture":1,"texture":1,"defaultItem":-1},"t-shirt":{"item":15,"defaultTexture":0,"texture":0,"defaultItem":1},"cheek_1":{"item":0,"defaultTexture":0,"texture":0,"defaultItem":0},"chimp_bone_lowering":{"item":0,"defaultTexture":0,"texture":0,"defaultItem":0},"eyebrown_high":{"item":0,"defaultTexture":0,"texture":0,"defaultItem":0},"face":{"item":2,"defaultTexture":0,"texture":0,"defaultItem":0},"jaw_bone_width":{"item":0,"defaultTexture":0,"texture":0,"defaultItem":0},"nose_1":{"item":2,"defaultTexture":0,"texture":0,"defaultItem":0},"lips_thickness":{"item":0,"defaultTexture":0,"texture":0,"defaultItem":0},"eye_opening":{"item":0,"defaultTexture":0,"texture":0,"defaultItem":0},"cheek_2":{"item":0,"defaultTexture":0,"texture":0,"defaultItem":0},"nose_5":{"item":0,"defaultTexture":0,"texture":0,"defaultItem":0},"mask":{"item":0,"defaultTexture":0,"texture":0,"defaultItem":0},"face2":{"item":2,"defaultTexture":0,"texture":0,"defaultItem":0},"bracelet":{"item":-1,"defaultTexture":0,"texture":0,"defaultItem":-1},"chimp_bone_width":{"item":0,"defaultTexture":0,"texture":0,"defaultItem":0},"decals":{"item":0,"defaultTexture":0,"texture":0,"defaultItem":0},"eye_color":{"item":6,"defaultTexture":0,"texture":0,"defaultItem":-1},"nose_2":{"item":0,"defaultTexture":0,"texture":0,"defaultItem":0},"vest":{"item":0,"defaultTexture":0,"texture":0,"defaultItem":0},"pants":{"item":4,"defaultTexture":0,"texture":0,"defaultItem":0},"lipstick":{"item":-1,"defaultTexture":1,"texture":1,"defaultItem":-1},"facemix":{"shapeMix":0.62,"defaultShapeMix":0.0,"defaultSkinMix":0.0,"skinMix":0.77},"watch":{"item":-1,"defaultTexture":0,"texture":0,"defaultItem":-1},"ear":{"item":-1,"defaultTexture":0,"texture":0,"defaultItem":-1},"chimp_hole":{"item":0,"defaultTexture":0,"texture":0,"defaultItem":0},"makeup":{"item":-1,"defaultTexture":1,"texture":1,"defaultItem":-1},"eyebrows":{"item":-1,"defaultTexture":1,"texture":1,"defaultItem":-1},"hat":{"item":-1,"defaultTexture":0,"texture":0,"defaultItem":-1}}', 1),
	(2, 'QIK97947', '1885233650', '{"facemix":{"defaultShapeMix":0.0,"defaultSkinMix":0.0,"skinMix":0,"shapeMix":0.27},"face":{"texture":0,"defaultItem":0,"item":0,"defaultTexture":0},"bag":{"texture":0,"defaultItem":0,"item":0,"defaultTexture":0},"makeup":{"texture":1,"defaultItem":-1,"item":-1,"defaultTexture":1},"face2":{"texture":0,"defaultItem":0,"item":0,"defaultTexture":0},"ear":{"texture":0,"defaultItem":-1,"item":-1,"defaultTexture":0},"lipstick":{"texture":1,"defaultItem":-1,"item":-1,"defaultTexture":1},"shoes":{"texture":0,"defaultItem":1,"item":1,"defaultTexture":0},"eye_opening":{"texture":0,"defaultItem":0,"item":0,"defaultTexture":0},"t-shirt":{"texture":0,"defaultItem":1,"item":1,"defaultTexture":0},"decals":{"texture":0,"defaultItem":0,"item":0,"defaultTexture":0},"moles":{"texture":0,"defaultItem":-1,"item":-1,"defaultTexture":0},"neck_thikness":{"texture":0,"defaultItem":0,"item":0,"defaultTexture":0},"chimp_hole":{"texture":0,"defaultItem":0,"item":0,"defaultTexture":0},"beard":{"texture":1,"defaultItem":-1,"item":-1,"defaultTexture":1},"chimp_bone_width":{"texture":0,"defaultItem":0,"item":0,"defaultTexture":0},"chimp_bone_lenght":{"texture":0,"defaultItem":0,"item":0,"defaultTexture":0},"jaw_bone_width":{"texture":0,"defaultItem":0,"item":0,"defaultTexture":0},"arms":{"texture":0,"defaultItem":0,"item":0,"defaultTexture":0},"pants":{"texture":0,"defaultItem":0,"item":0,"defaultTexture":0},"cheek_2":{"texture":0,"defaultItem":0,"item":0,"defaultTexture":0},"watch":{"texture":0,"defaultItem":-1,"item":-1,"defaultTexture":0},"nose_1":{"texture":0,"defaultItem":0,"item":0,"defaultTexture":0},"torso2":{"texture":0,"defaultItem":0,"item":0,"defaultTexture":0},"hat":{"texture":0,"defaultItem":-1,"item":-1,"defaultTexture":0},"blush":{"texture":1,"defaultItem":-1,"item":-1,"defaultTexture":1},"eyebrown_high":{"texture":0,"defaultItem":0,"item":0,"defaultTexture":0},"hair":{"texture":0,"defaultItem":0,"item":0,"defaultTexture":0},"ageing":{"texture":0,"defaultItem":-1,"item":-1,"defaultTexture":0},"vest":{"texture":0,"defaultItem":0,"item":0,"defaultTexture":0},"chimp_bone_lowering":{"texture":0,"defaultItem":0,"item":0,"defaultTexture":0},"lips_thickness":{"texture":0,"defaultItem":0,"item":0,"defaultTexture":0},"cheek_3":{"texture":0,"defaultItem":0,"item":0,"defaultTexture":0},"eyebrows":{"texture":1,"defaultItem":-1,"item":-1,"defaultTexture":1},"jaw_bone_back_lenght":{"texture":0,"defaultItem":0,"item":0,"defaultTexture":0},"nose_2":{"texture":0,"defaultItem":0,"item":0,"defaultTexture":0},"glass":{"texture":0,"defaultItem":0,"item":0,"defaultTexture":0},"bracelet":{"texture":0,"defaultItem":-1,"item":-1,"defaultTexture":0},"nose_5":{"texture":0,"defaultItem":0,"item":0,"defaultTexture":0},"nose_0":{"texture":0,"defaultItem":0,"item":0,"defaultTexture":0},"nose_4":{"texture":0,"defaultItem":0,"item":0,"defaultTexture":0},"nose_3":{"texture":0,"defaultItem":0,"item":0,"defaultTexture":0},"eyebrown_forward":{"texture":0,"defaultItem":0,"item":0,"defaultTexture":0},"eye_color":{"texture":0,"defaultItem":-1,"item":-1,"defaultTexture":0},"accessory":{"texture":0,"defaultItem":0,"item":0,"defaultTexture":0},"cheek_1":{"texture":0,"defaultItem":0,"item":0,"defaultTexture":0},"mask":{"texture":0,"defaultItem":0,"item":0,"defaultTexture":0}}', 1),
	(3, 'UXN47399', '1885233650', '{"vest":{"defaultItem":0,"defaultTexture":0,"item":0,"texture":0},"accessory":{"defaultItem":0,"defaultTexture":0,"item":0,"texture":0},"moles":{"defaultItem":-1,"defaultTexture":0,"item":-1,"texture":0},"lipstick":{"defaultItem":-1,"defaultTexture":1,"item":-1,"texture":1},"t-shirt":{"defaultItem":1,"defaultTexture":0,"item":1,"texture":0},"bag":{"defaultItem":0,"defaultTexture":0,"item":0,"texture":0},"shoes":{"defaultItem":1,"defaultTexture":0,"item":1,"texture":0},"hat":{"defaultItem":-1,"defaultTexture":0,"item":-1,"texture":0},"eye_color":{"defaultItem":-1,"defaultTexture":0,"item":-1,"texture":0},"face":{"defaultItem":0,"defaultTexture":0,"item":0,"texture":0},"blush":{"defaultItem":-1,"defaultTexture":1,"item":-1,"texture":1},"arms":{"defaultItem":0,"defaultTexture":0,"item":0,"texture":0},"eyebrown_forward":{"defaultItem":0,"defaultTexture":0,"item":0,"texture":0},"jaw_bone_back_lenght":{"defaultItem":0,"defaultTexture":0,"item":0,"texture":0},"chimp_hole":{"defaultItem":0,"defaultTexture":0,"item":0,"texture":0},"chimp_bone_lowering":{"defaultItem":0,"defaultTexture":0,"item":0,"texture":0},"ageing":{"defaultItem":-1,"defaultTexture":0,"item":-1,"texture":0},"beard":{"defaultItem":-1,"defaultTexture":1,"item":-1,"texture":1},"ear":{"defaultItem":-1,"defaultTexture":0,"item":-1,"texture":0},"cheek_1":{"defaultItem":0,"defaultTexture":0,"item":0,"texture":0},"nose_1":{"defaultItem":0,"defaultTexture":0,"item":0,"texture":0},"nose_2":{"defaultItem":0,"defaultTexture":0,"item":0,"texture":0},"face2":{"defaultItem":0,"defaultTexture":0,"item":0,"texture":0},"eye_opening":{"defaultItem":0,"defaultTexture":0,"item":0,"texture":0},"facemix":{"defaultShapeMix":0.0,"defaultSkinMix":0.0,"skinMix":0,"shapeMix":0},"lips_thickness":{"defaultItem":0,"defaultTexture":0,"item":0,"texture":0},"pants":{"defaultItem":0,"defaultTexture":0,"item":0,"texture":0},"neck_thikness":{"defaultItem":0,"defaultTexture":0,"item":0,"texture":0},"chimp_bone_width":{"defaultItem":0,"defaultTexture":0,"item":0,"texture":0},"watch":{"defaultItem":-1,"defaultTexture":0,"item":-1,"texture":0},"eyebrown_high":{"defaultItem":0,"defaultTexture":0,"item":0,"texture":0},"glass":{"defaultItem":0,"defaultTexture":0,"item":0,"texture":0},"cheek_2":{"defaultItem":0,"defaultTexture":0,"item":0,"texture":0},"mask":{"defaultItem":0,"defaultTexture":0,"item":0,"texture":0},"cheek_3":{"defaultItem":0,"defaultTexture":0,"item":0,"texture":0},"nose_5":{"defaultItem":0,"defaultTexture":0,"item":0,"texture":0},"makeup":{"defaultItem":-1,"defaultTexture":1,"item":-1,"texture":1},"hair":{"defaultItem":0,"defaultTexture":0,"item":0,"texture":0},"nose_0":{"defaultItem":0,"defaultTexture":0,"item":0,"texture":0},"nose_3":{"defaultItem":0,"defaultTexture":0,"item":0,"texture":0},"decals":{"defaultItem":0,"defaultTexture":0,"item":0,"texture":0},"torso2":{"defaultItem":0,"defaultTexture":0,"item":0,"texture":0},"chimp_bone_lenght":{"defaultItem":0,"defaultTexture":0,"item":0,"texture":0},"bracelet":{"defaultItem":-1,"defaultTexture":0,"item":-1,"texture":0},"jaw_bone_width":{"defaultItem":0,"defaultTexture":0,"item":0,"texture":0},"nose_4":{"defaultItem":0,"defaultTexture":0,"item":0,"texture":0},"eyebrows":{"defaultItem":-1,"defaultTexture":1,"item":-1,"texture":1}}', 1),
	(4, 'SWX89939', '1885233650', '{"bracelet":{"defaultTexture":0,"item":-1,"defaultItem":-1,"texture":0},"face":{"defaultTexture":0,"item":6,"defaultItem":0,"texture":0},"moles":{"defaultTexture":0,"item":4,"defaultItem":-1,"texture":0},"ear":{"defaultTexture":0,"item":-1,"defaultItem":-1,"texture":0},"nose_2":{"defaultTexture":0,"item":11,"defaultItem":0,"texture":0},"watch":{"defaultTexture":0,"item":-1,"defaultItem":-1,"texture":0},"chimp_bone_lowering":{"defaultTexture":0,"item":0,"defaultItem":0,"texture":0},"hair":{"defaultTexture":0,"item":0,"defaultItem":0,"texture":0},"eye_opening":{"defaultTexture":0,"item":0,"defaultItem":0,"texture":0},"pants":{"defaultTexture":0,"item":0,"defaultItem":0,"texture":0},"shoes":{"defaultTexture":0,"item":3,"defaultItem":1,"texture":0},"face2":{"defaultTexture":0,"item":8,"defaultItem":0,"texture":0},"chimp_bone_lenght":{"defaultTexture":0,"item":0,"defaultItem":0,"texture":0},"eyebrown_high":{"defaultTexture":0,"item":0,"defaultItem":0,"texture":0},"glass":{"defaultTexture":0,"item":0,"defaultItem":0,"texture":0},"nose_1":{"defaultTexture":0,"item":15,"defaultItem":0,"texture":0},"lipstick":{"defaultTexture":1,"item":-1,"defaultItem":-1,"texture":1},"blush":{"defaultTexture":1,"item":-1,"defaultItem":-1,"texture":1},"jaw_bone_back_lenght":{"defaultTexture":0,"item":0,"defaultItem":0,"texture":0},"vest":{"defaultTexture":0,"item":0,"defaultItem":0,"texture":0},"chimp_bone_width":{"defaultTexture":0,"item":0,"defaultItem":0,"texture":0},"cheek_3":{"defaultTexture":0,"item":0,"defaultItem":0,"texture":0},"eyebrows":{"defaultTexture":1,"item":-1,"defaultItem":-1,"texture":1},"t-shirt":{"defaultTexture":0,"item":15,"defaultItem":1,"texture":0},"nose_0":{"defaultTexture":0,"item":6,"defaultItem":0,"texture":0},"eye_color":{"defaultTexture":0,"item":-1,"defaultItem":-1,"texture":0},"mask":{"defaultTexture":0,"item":0,"defaultItem":0,"texture":0},"arms":{"defaultTexture":0,"item":5,"defaultItem":0,"texture":0},"beard":{"defaultTexture":1,"item":-1,"defaultItem":-1,"texture":1},"chimp_hole":{"defaultTexture":0,"item":0,"defaultItem":0,"texture":0},"decals":{"defaultTexture":0,"item":0,"defaultItem":0,"texture":0},"hat":{"defaultTexture":0,"item":-1,"defaultItem":-1,"texture":0},"jaw_bone_width":{"defaultTexture":0,"item":0,"defaultItem":0,"texture":0},"lips_thickness":{"defaultTexture":0,"item":0,"defaultItem":0,"texture":0},"nose_5":{"defaultTexture":0,"item":0,"defaultItem":0,"texture":0},"makeup":{"defaultTexture":1,"item":-1,"defaultItem":-1,"texture":1},"cheek_2":{"defaultTexture":0,"item":0,"defaultItem":0,"texture":0},"cheek_1":{"defaultTexture":0,"item":0,"defaultItem":0,"texture":0},"torso2":{"defaultTexture":0,"item":11,"defaultItem":0,"texture":0},"nose_3":{"defaultTexture":0,"item":0,"defaultItem":0,"texture":0},"nose_4":{"defaultTexture":0,"item":0,"defaultItem":0,"texture":0},"bag":{"defaultTexture":0,"item":0,"defaultItem":0,"texture":0},"eyebrown_forward":{"defaultTexture":0,"item":0,"defaultItem":0,"texture":0},"accessory":{"defaultTexture":0,"item":0,"defaultItem":0,"texture":0},"neck_thikness":{"defaultTexture":0,"item":0,"defaultItem":0,"texture":0},"facemix":{"skinMix":0.82,"defaultShapeMix":0.0,"shapeMix":0.87,"defaultSkinMix":0.0},"ageing":{"defaultTexture":0,"item":-1,"defaultItem":-1,"texture":0}}', 1);
/*!40000 ALTER TABLE `playerskins` ENABLE KEYS */;

-- Dumping structure for table denalifwstd.player_boats
CREATE TABLE IF NOT EXISTS `player_boats` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `citizenid` varchar(50) DEFAULT NULL,
  `model` varchar(50) DEFAULT NULL,
  `plate` varchar(50) DEFAULT NULL,
  `boathouse` varchar(50) DEFAULT NULL,
  `fuel` int(11) NOT NULL DEFAULT 100,
  `state` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `citizenid` (`citizenid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table denalifwstd.player_boats: ~0 rows (approximately)
/*!40000 ALTER TABLE `player_boats` DISABLE KEYS */;
/*!40000 ALTER TABLE `player_boats` ENABLE KEYS */;

-- Dumping structure for table denalifwstd.player_contacts
CREATE TABLE IF NOT EXISTS `player_contacts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `citizenid` varchar(50) DEFAULT NULL,
  `name` varchar(50) DEFAULT NULL,
  `number` varchar(50) DEFAULT NULL,
  `iban` varchar(50) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `citizenid` (`citizenid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table denalifwstd.player_contacts: ~0 rows (approximately)
/*!40000 ALTER TABLE `player_contacts` DISABLE KEYS */;
/*!40000 ALTER TABLE `player_contacts` ENABLE KEYS */;

-- Dumping structure for table denalifwstd.player_houses
CREATE TABLE IF NOT EXISTS `player_houses` (
  `id` int(255) NOT NULL AUTO_INCREMENT,
  `house` varchar(50) NOT NULL,
  `identifier` varchar(50) DEFAULT NULL,
  `citizenid` varchar(50) DEFAULT NULL,
  `keyholders` text DEFAULT NULL,
  `decorations` text DEFAULT NULL,
  `stash` text DEFAULT NULL,
  `outfit` text DEFAULT NULL,
  `logout` text DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `house` (`house`),
  KEY `citizenid` (`citizenid`),
  KEY `identifier` (`identifier`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

-- Dumping data for table denalifwstd.player_houses: ~1 rows (approximately)
/*!40000 ALTER TABLE `player_houses` DISABLE KEYS */;
INSERT INTO `player_houses` (`id`, `house`, `identifier`, `citizenid`, `keyholders`, `decorations`, `stash`, `outfit`, `logout`) VALUES
	(1, 'olympic fwy1', 'license:3de8fa5314866ffce7a517e626d26ef6d0676264', 'SWX89939', '["SWX89939"]', NULL, '{"y":-1209.4539794921876,"z":1.6979900598526,"x":-55.92578506469726}', '{"y":-1207.710693359375,"z":1.69799053668975,"x":-54.19847106933594}', NULL);
/*!40000 ALTER TABLE `player_houses` ENABLE KEYS */;

-- Dumping structure for table denalifwstd.player_mails
CREATE TABLE IF NOT EXISTS `player_mails` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `citizenid` varchar(50) DEFAULT NULL,
  `sender` varchar(50) DEFAULT NULL,
  `subject` varchar(50) DEFAULT NULL,
  `message` text DEFAULT NULL,
  `read` tinyint(4) DEFAULT 0,
  `mailid` int(11) DEFAULT NULL,
  `date` timestamp NULL DEFAULT current_timestamp(),
  `button` text DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `citizenid` (`citizenid`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

-- Dumping data for table denalifwstd.player_mails: ~2 rows (approximately)
/*!40000 ALTER TABLE `player_mails` DISABLE KEYS */;
INSERT INTO `player_mails` (`id`, `citizenid`, `sender`, `subject`, `message`, `read`, `mailid`, `date`, `button`) VALUES
	(1, 'SWX89939', 'Pillbox Hospital', 'Hospital Costs', 'Dear Mr. Testing, <br /><br />Hereby you received an email with the costs of the last hospital visit.<br />The final costs have become: <strong>$2000</strong><br /><br />We wish you a quick recovery!', 0, 431941, '2022-02-02 15:32:05', '[]'),
	(2, 'SWX89939', 'Pillbox Hospital', 'Hospital Costs', 'Dear Mr. Testing, <br /><br />Hereby you received an email with the costs of the last hospital visit.<br />The final costs have become: <strong>$2000</strong><br /><br />We wish you a quick recovery!', 0, 160250, '2022-02-02 15:32:39', '[]');
/*!40000 ALTER TABLE `player_mails` ENABLE KEYS */;

-- Dumping structure for table denalifwstd.player_outfits
CREATE TABLE IF NOT EXISTS `player_outfits` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `citizenid` varchar(50) DEFAULT NULL,
  `outfitname` varchar(50) NOT NULL,
  `model` varchar(50) DEFAULT NULL,
  `skin` text DEFAULT NULL,
  `outfitId` varchar(50) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `citizenid` (`citizenid`),
  KEY `outfitId` (`outfitId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table denalifwstd.player_outfits: ~0 rows (approximately)
/*!40000 ALTER TABLE `player_outfits` DISABLE KEYS */;
/*!40000 ALTER TABLE `player_outfits` ENABLE KEYS */;

-- Dumping structure for table denalifwstd.player_vehicles
CREATE TABLE IF NOT EXISTS `player_vehicles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `license` varchar(50) DEFAULT NULL,
  `citizenid` varchar(50) DEFAULT NULL,
  `vehicle` varchar(50) DEFAULT NULL,
  `hash` varchar(50) DEFAULT NULL,
  `mods` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `plate` varchar(50) NOT NULL,
  `fakeplate` varchar(50) DEFAULT NULL,
  `garage` varchar(50) DEFAULT NULL,
  `fuel` int(11) DEFAULT 100,
  `engine` float DEFAULT 1000,
  `body` float DEFAULT 1000,
  `state` int(11) DEFAULT 1,
  `depotprice` int(11) NOT NULL DEFAULT 0,
  `drivingdistance` int(50) DEFAULT NULL,
  `status` text DEFAULT NULL,
  `balance` int(11) NOT NULL DEFAULT 0,
  `paymentamount` int(11) NOT NULL DEFAULT 0,
  `paymentsleft` int(11) NOT NULL DEFAULT 0,
  `financetime` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `plate` (`plate`),
  KEY `citizenid` (`citizenid`),
  KEY `license` (`license`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table denalifwstd.player_vehicles: ~0 rows (approximately)
/*!40000 ALTER TABLE `player_vehicles` DISABLE KEYS */;
/*!40000 ALTER TABLE `player_vehicles` ENABLE KEYS */;

-- Dumping structure for table denalifwstd.player_warns
CREATE TABLE IF NOT EXISTS `player_warns` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `senderIdentifier` varchar(50) DEFAULT NULL,
  `targetIdentifier` varchar(50) DEFAULT NULL,
  `reason` text DEFAULT NULL,
  `warnId` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table denalifwstd.player_warns: ~0 rows (approximately)
/*!40000 ALTER TABLE `player_warns` DISABLE KEYS */;
/*!40000 ALTER TABLE `player_warns` ENABLE KEYS */;

-- Dumping structure for table denalifwstd.stashitems
CREATE TABLE IF NOT EXISTS `stashitems` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `stash` varchar(255) NOT NULL DEFAULT '[]',
  `items` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  PRIMARY KEY (`stash`),
  KEY `id` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

-- Dumping data for table denalifwstd.stashitems: ~2 rows (approximately)
/*!40000 ALTER TABLE `stashitems` DISABLE KEYS */;
INSERT INTO `stashitems` (`id`, `stash`, `items`) VALUES
	(1, 'apartment51731', '[]'),
	(2, 'olympic fwy1', '[]');
/*!40000 ALTER TABLE `stashitems` ENABLE KEYS */;

-- Dumping structure for table denalifwstd.trunkitems
CREATE TABLE IF NOT EXISTS `trunkitems` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `plate` varchar(255) NOT NULL DEFAULT '[]',
  `items` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  PRIMARY KEY (`plate`),
  KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table denalifwstd.trunkitems: ~0 rows (approximately)
/*!40000 ALTER TABLE `trunkitems` DISABLE KEYS */;
/*!40000 ALTER TABLE `trunkitems` ENABLE KEYS */;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
