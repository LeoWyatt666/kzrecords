<?
set_time_limit(240);

$dbconf = array (
	'mysql_host' => 'localhost',
	'mysql_user' => 'lonis',
	'mysql_password' => 'lonis',
	'mysql_db' => 'lonis',
	'mysql_prefix' => '',
);

$path = "D:/Documents/public_html/lonis/update/";

$demos = [
		"xj"	=> ["demos/demos_xj.txt",	"http://xtreme-jumps.eu/demos.txt"],
		"cc"	=> ["demos/demos_cc.txt",	"https://cosy-climbing.net/demos.txt"],
		"ru"	=> ["demos/demos_kzru.txt",	"http://kzru.one/demos.txt"],
		"rush"	=> ["demos/demos_rush.txt",	"http://kz-rush.ru/demos.txt"],
];

foreach ($demos as $key=>$val) {
	$c = file_get_contents($val[0]);
	$d = file_get_contents($val[1]);

	if($c==$d && $d!=0) continue;

	file_put_contents($d);
}



$db = new PDO('mysql:host='.$dbconf['mysql_host'].';dbname='.$dbconf['mysql_db'],
		$dbconf['mysql_user'], $dbconf['mysql_password'],
		[PDO::MYSQL_ATTR_LOCAL_INFILE => true,
		PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION]);

$sqlf = file_get_contents("upd_kz_records.sql");
$sqlm = explode(";", $sqlf);


foreach($sqlm as $sql) {
	if(empty($sql)) continue;

	foreach($demos as $val) {
		$sql = str_replace($val[0], $path.$val[0], $sql);
	}

	$db->query($sql);
}


?>