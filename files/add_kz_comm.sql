-- --------------------------------------------------------
-- Хост:                         127.0.0.1
-- Версия сервера:               5.7.18 - MySQL Community Server (GPL)
-- Операционная система:         Win32
-- HeidiSQL Версия:              9.5.0.5196
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;

-- Дамп структуры для таблица lonis.kz_comm
CREATE TABLE IF NOT EXISTS `kz_comm` (
  `sort` int(10) NOT NULL,
  `name` varchar(8) NOT NULL,
  `fullname` varchar(16) NOT NULL,
  `url` varchar(64) DEFAULT NULL,
  `demos` varchar(128) DEFAULT NULL,
  `image` varchar(256) DEFAULT NULL,
  `download` varchar(256) DEFAULT NULL,
  `mapinfo` varchar(256) DEFAULT NULL,
  PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Дамп данных таблицы lonis.kz_comm: ~4 rows (приблизительно)
DELETE FROM `kz_comm`;
/*!40000 ALTER TABLE `kz_comm` DISABLE KEYS */;
INSERT INTO `kz_comm` (`sort`, `name`, `fullname`, `url`, `demos`, `image`, `download`, `mapinfo`) VALUES
	(2, 'cc', 'Cosy-Climbing', 'https://cosy-climbing.net', 'https://cosy-climbing.net/demoz.txt', 'https://cosy-climbing.net/img/maps/%map%.png', 'https://cosy-climbing.net/files/maps/%map%.rar', 'https://cosy-climbing.net/search.php?q=%map%&in=&ex=&ep=&be=%map%&t=all&r=0&s=Search&adv=0'),
	(3, 'ru', 'KZ-Russia', 'http://kzru.one', 'http://kzru.one/demos.txt', 'http://kzru.one/plugins/lgsl/lgsl_files/lgsl_image.php?map=%map%', 'http://kzru.one/maps/%map%', 'http://kzru.one/maps/%map%'),
	(4, 'rush', 'Kz-Rush', 'http://kz-rush.ru', 'http://kz-rush.ru/demos.txt', 'http://kz-rush.ru/xr_images/maps/%map%.jpg', 'http://kz-rush.ru/maps/%map%', 'http://kz-rush.ru/maps/%map%'),
	(1, 'xj', 'Xtreme-Jumps', 'https://xtreme-jumps.eu', 'https://xtreme-jumps.eu/demos.txt', 'http://xtreme-jumps.eu/e107_plugins/lgsl_menu/images/mapz/halflife2/cstrike/%map%.jpg', 'http://files.xtreme-jumps.eu/maps/%map%.rar', 'http://xtreme-jumps.eu/demos_history/map_info.php?map=%map%');
/*!40000 ALTER TABLE `kz_comm` ENABLE KEYS */;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
