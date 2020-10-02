CREATE TABLE `stg_apkdetails` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`appId` TEXT(65535) NOT NULL COLLATE 'latin1_swedish_ci',
	`title` TEXT(65535) NULL DEFAULT NULL COLLATE 'latin1_swedish_ci',
	`description` TEXT(65535) NULL DEFAULT NULL COLLATE 'latin1_swedish_ci',
	`descriptionHTML` TEXT(65535) NULL DEFAULT NULL COLLATE 'latin1_swedish_ci',
	`summary` TEXT(65535) NULL DEFAULT NULL COLLATE 'latin1_swedish_ci',
	`scoreText` TEXT(65535) NULL DEFAULT NULL COLLATE 'latin1_swedish_ci',
	`size` TEXT(65535) NULL DEFAULT NULL COLLATE 'latin1_swedish_ci',
	`androidVersionText` TEXT(65535) NULL DEFAULT NULL COLLATE 'latin1_swedish_ci',
	`developer__devId` TEXT(65535) NULL DEFAULT NULL COLLATE 'latin1_swedish_ci',
	`genreId` TEXT(65535) NULL DEFAULT NULL COLLATE 'latin1_swedish_ci',
	`icon` TEXT(65535) NULL DEFAULT NULL COLLATE 'latin1_swedish_ci',
	`headerImage` TEXT(65535) NULL DEFAULT NULL COLLATE 'latin1_swedish_ci',
	`screenshots` TEXT(65535) NULL DEFAULT NULL COLLATE 'latin1_swedish_ci',
	`version` TEXT(65535) NULL DEFAULT NULL COLLATE 'latin1_swedish_ci',
	`updated` TEXT(65535) NULL DEFAULT NULL COLLATE 'latin1_swedish_ci',
	PRIMARY KEY (`id`, `appId`(100)) USING BTREE
)
COLLATE='latin1_swedish_ci'
ENGINE=MyISAM
AUTO_INCREMENT=201
;
