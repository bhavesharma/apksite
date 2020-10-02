CREATE TABLE `apklogs` (
	`post_id` INT(11) NULL DEFAULT NULL,
	`media_id` INT(11) NULL DEFAULT NULL,
	`app_id` TEXT(65535) NULL DEFAULT NULL COLLATE 'latin1_swedish_ci',
	`p_date` TIMESTAMP NULL DEFAULT NULL
)
COLLATE='latin1_swedish_ci'
ENGINE=InnoDB
;
