<?php
$host = "localhost";
$user = "root";
$pass = "";
$dbname = "budget_db";

$con = mysqli_connect($host, $user, $pass, $dbname);

if(!$con){
    die(json_encode(['code'=>500,'message'=>'Database connection failed']));
}
?>
