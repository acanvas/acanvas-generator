<?
$conn = mysql_connect ( '@accounts.db.host@', '@accounts.db.user@', '@accounts.db.pass@' );
mysql_query("CREATE DATABASE IF NOT EXISTS @accounts.db.name@",$conn);
mysql_select_db ( '@accounts.db.name@', $conn );
mysql_query("set names 'utf8'"); 

$fp = file('tables.sql', FILE_IGNORE_NEW_LINES | FILE_SKIP_EMPTY_LINES);
$query = '';
foreach ($fp as $line) {
    if ($line != '' && strpos($line, '--') === false) {
        $query .= $line;
        if (substr($query, -1) == ';') {
        	echo $query . "<br/>";
            mysql_query($query);
            $query = '';
        }
    }
}
?>