<?php
$conn = mysqli_connect("localhost","root","","artist_hub_db");

if(!$conn){
    die("DB connection failed");
}

header("Content-Type: application/json");

function response($status,$message,$data=null){
    echo json_encode([
        "status"=>$status,
        "message"=>$message,
        "data"=>$data
    ]);
    exit;
}

function clean($data){
    return htmlspecialchars(strip_tags(trim($data)));
}

function isEmail($email){
    return filter_var($email, FILTER_VALIDATE_EMAIL);
}
?>
