<?
set_time_limit(240);

// Db config
$dbconf = array (
	'mysql_host' => 'localhost',
	'mysql_user' => 'lonis',
	'mysql_password' => 'lonis',
	'mysql_db' => 'lonis',
	'mysql_prefix' => '',
);

// Absolute Path!
$path = "data/kzrecords/";

$demos = [
		"xj"	=> ["demos_xj.txt",		"https://xtreme-jumps.eu/demos.txt"],
		"cc"	=> ["demos_cc.txt",		"https://cosy-climbing.net/demoz.txt"],
		"ru"	=> ["demos_ru.txt",		"http://kzru.one/demos.txt"],
		"rush"	=> ["demos_rush.txt",	"http://kz-rush.ru/demos.txt"],
];

if(!file_exists($path))
	mkdir($path);

// Get & Put files
foreach ($demos as $key=>$val) {
	$f = $path.$val[0];
	if(!file_exists($f))
		continue;

	$c = file_get_contents($f);

	$d = file_get_contents($val[1]);

	if($c==$d && $d!=0) continue;

	file_put_contents($f, $d);
}

// Connect DB Infile Mode
$db = new PDO('mysql:host='.$dbconf['mysql_host'].';dbname='.$dbconf['mysql_db'],
		$dbconf['mysql_user'], $dbconf['mysql_password'],
		[PDO::MYSQL_ATTR_LOCAL_INFILE => true,
		PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION]);

// Load SQL from file
$sqlf = file_get_contents("upd_kz_records.sql");

// Cxecute SQL
$sqlm = explode(";", $sqlf);
foreach($sqlm as $sql) {
	if(empty($sql)) continue;

	// Replace Local to Absolute Path
	foreach($demos as $val) {
		$sql = str_replace($val[0], $path.$val[0], $sql);
	}

	$db->query($sql);
}


?>