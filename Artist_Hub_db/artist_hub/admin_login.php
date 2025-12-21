<?php
include "connect.php";

/* STATIC ADMIN CREDENTIALS */
$ADMIN_EMAIL = "admin@artisthub.com";
$ADMIN_PASSWORD = "admin123";  // plain text (simple static, production માં hash recommended)

/* INPUT */
$email    = trim($_POST['email'] ?? '');
$password = trim($_POST['password'] ?? '');

/* VALIDATION */
if($email == '') response(false,"Email is required");
if($password == '') response(false,"Password is required");

/* CHECK CREDENTIALS */
if($email !== $ADMIN_EMAIL || $password !== $ADMIN_PASSWORD){
    response(false,"Invalid email or password");
}

/* SUCCESS RESPONSE */
$data = [
    "id"    => 1,
    "name"  => "Admin",
    "email" => $ADMIN_EMAIL,
    "role"  => "admin"
];

response(true,"Admin login successful",$data);
