<?php
declare(strict_types=1);

$db = null;
$db_error = null;

$DB_HOST = 'localhost';
$DB_NAME = 'loona_bd';
$DB_USER = 'root';
$DB_PASS = '';
$DB_CHARSET = 'utf8mb4';

mysqli_report(MYSQLI_REPORT_ERROR | MYSQLI_REPORT_STRICT);

try {
    $db = new mysqli($DB_HOST, $DB_USER, $DB_PASS, $DB_NAME);
    $db->set_charset($DB_CHARSET);
} catch (mysqli_sql_exception $e) {
    $db_error = $e->getMessage();
    $db = null;
}
