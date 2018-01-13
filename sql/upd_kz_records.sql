DELETE FROM `kz_records`;

ALTER TABLE `kz_records` AUTO_INCREMENT = 0;

DROP TABLE IF EXISTS `demos`;
CREATE TEMPORARY TABLE `demos` (
	`map` VARCHAR(64) NOT NULL,
	`time` DECIMAL(10,2) NULL DEFAULT NULL,
	`player` VARCHAR(32) NULL DEFAULT NULL,
	`country` VARCHAR(8) NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOAD DATA LOCAL INFILE 'demos/demos_cc.txt'
INTO TABLE `demos` CHARACTER SET 'UTF8' FIELDS TERMINATED BY ' ' IGNORE 1 LINES
(`map`, `time`, @ignored, @ignored, @ignored, `country`, `player`);

INSERT INTO `kz_records` (`map`, `mappath`, `time`,`player`, `country`, `comm`)
SELECT
	IF(LOCATE("[", `map`), LEFT(`map`, LOCATE("[", `map`)-1), `map`) AS `map`,
	MID(`map`, LOCATE("[", `map`), LOCATE("]", `map`)) AS `mappath`,
	IF(`time` = 0, NULL, `time`) AS `time`,
	IF(`player` = 'n/a', NULL, `player`) AS `player`,
	IF(`country` = 'n-a' , NULL, `country`) AS `country`,
	'cc' AS `comm`
FROM `demos`;

DELETE FROM `demos`;
LOAD DATA LOCAL INFILE 'demos/demos_xj.txt'
INTO TABLE `demos` CHARACTER SET 'UTF8' FIELDS TERMINATED BY ' ' IGNORE 1 LINES
(`map`, `time`,`player`, `country`);

INSERT INTO `kz_records` (`map`, `mappath`, `time`,`player`, `country`, `comm`)
SELECT
	IF(LOCATE("[", `map`), LEFT(`map`, LOCATE("[", `map`)-1), `map`) AS `map`,
	MID(`map`, LOCATE("[", `map`), LOCATE("]", `map`)) AS `mappath`,
	IF(`time` = 0, NULL, `time`) AS `time`,
	IF(`player` = 'n/a', NULL, `player`) AS `player`,
	IF(`country` = 'n-a' , NULL, `country`) AS `country`,
	'xj' AS `comm`
FROM `demos`;

DELETE FROM `demos`;
LOAD DATA LOCAL INFILE 'demos/demos_kzru.txt'
INTO TABLE `demos` CHARACTER SET 'UTF8' FIELDS TERMINATED BY ' ' IGNORE 1 LINES
(`map`, `time`, `player`);

INSERT INTO `kz_records` (`map`, `mappath`, `time`,`player`, `country`, `comm`)
SELECT
	IF(LOCATE("[", `map`), LEFT(`map`, LOCATE("[", `map`)-1), `map`) AS `map`,
	MID(`map`, LOCATE("[", `map`), LOCATE("]", `map`)) AS `mappath`,
	IF(`time` = 0, NULL, `time`) AS `time`,
	IF(`player` = 'n/a', NULL, `player`) AS `player`,
	'ru' AS `country`,
	'ru' AS `comm`
FROM `demos`;

DELETE FROM `demos`;
LOAD DATA LOCAL INFILE 'demos/demos_rush.txt'
INTO TABLE `demos` CHARACTER SET 'UTF8' FIELDS TERMINATED BY ' ' IGNORE 1 LINES
(`map`, `time`,`player`, `country`);

INSERT INTO `kz_records` (`map`, `mappath`, `time`,`player`, `country`, `comm`)
SELECT
	IF(LOCATE("[", `map`), LEFT(`map`, LOCATE("[", `map`)-1), `map`) AS `map`,
	MID(`map`, LOCATE("[", `map`), LOCATE("]", `map`)) AS `mappath`,
	IF(`time` = 0, NULL, `time`) AS `time`,
	IF(`player` = 'n/a', NULL, `player`) AS `player`,
	IF(`country` = 'n-a' , NULL, `country`) AS `country`,
	'rush' AS `comm`
FROM `demos`;

DROP TABLE IF EXISTS `demos`;