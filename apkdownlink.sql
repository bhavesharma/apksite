CREATE TABLE `apkdetails` (
  `id` int(11) NOT NULL,
  `appId` text NOT NULL,
  `title` text DEFAULT NULL,
  `description` text DEFAULT NULL,
  `descriptionHTML` text DEFAULT NULL,
  `summary` text DEFAULT NULL,
  `scoreText` text DEFAULT NULL,
  `size` text DEFAULT NULL,
  `androidVersionText` text DEFAULT NULL,
  `developer__devId` text DEFAULT NULL,
  `genreId` text DEFAULT NULL,
  `icon` text DEFAULT NULL,
  `headerImage` text DEFAULT NULL,
  `screenshots` text DEFAULT NULL,
  `video` text DEFAULT 'NULL',
  `version` text DEFAULT NULL,
  `updated` text DEFAULT NULL,
  `b2apk` char(1) DEFAULT 'N',
  `tobupdated` char(1) DEFAULT 'N',
  `md5` text DEFAULT NULL,
  PRIMARY KEY (`appId`(100)) USING BTREE
) ENGINE=MyISAM DEFAULT CHARSET=latin1;




-------------------------------------------

CREATE TABLE `apklogs` (
  `post_id` int(11) DEFAULT NULL,
  `media_id` int(11) DEFAULT NULL,
  `app_id` text DEFAULT NULL,
  `p_date` timestamp NULL DEFAULT NULL,
  `status` varchar(45) DEFAULT 'Active'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


--------------------------------------------

CREATE TABLE `stg_apkdetails` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `appId` text NOT NULL,
  `title` text DEFAULT NULL,
  `description` text DEFAULT NULL,
  `descriptionHTML` text DEFAULT NULL,
  `summary` text DEFAULT NULL,
  `scoreText` text DEFAULT NULL,
  `size` text DEFAULT NULL,
  `androidVersionText` text DEFAULT NULL,
  `developer__devId` text DEFAULT NULL,
  `genreId` text DEFAULT NULL,
  `icon` text DEFAULT NULL,
  `headerImage` text DEFAULT NULL,
  `screenshots` text DEFAULT NULL,
  `video` text DEFAULT NULL,
  `version` text DEFAULT NULL,
  `updated` text DEFAULT NULL,
  PRIMARY KEY (`id`,`appId`(100)) USING BTREE
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
