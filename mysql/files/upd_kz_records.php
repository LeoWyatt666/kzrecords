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

// Connect DB Infile Mode
$db = new PDO('mysql:host='.$dbconf['mysql_host'].';dbname='.$dbconf['mysql_db'],
		$dbconf['mysql_user'], $dbconf['mysql_password'],
		[PDO::MYSQL_ATTR_LOCAL_INFILE => true,
		PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
		PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC]);

$stm = $db->query("SELECT name, demos FROM kz_comm");
$demos = $stm->fetchall();

echo "<pre>";

// Get & Put files
foreach ($demos as $comm) {
	echo "get {$comm['demos']}\n ";
	$c = file_get_contents($comm['demos']);

	$f = "demos_{$comm['name']}.txt";
	$d = file_exists($f) ? file_get_contents($f) : 0;

	if($c==$d && $d!=0) continue;

	echo "put {$f}\n ";
	file_put_contents($f, $c);
}

// Load SQL from file
$sqlf = file_get_contents("upd_kz_records.sql");

// Replace Local to Absolute Path
foreach($demos as $comm) {
	$f = "demos_{$comm['name']}.txt";
	$ff = addslashes(__DIR__."\\".$f);
	$sqlf = str_replace($f, $ff, $sqlf);
}

// Execute SQL
$sqlm = explode(";", $sqlf);
foreach($sqlm as $sql) {
	if(empty($sql)) continue;

	$db->query($sql);
}

foreach ($demos as $comm) {
	$f = "demos_{$comm['name']}.txt";
	if(file_exists($f)) unlink($f);
}

?>