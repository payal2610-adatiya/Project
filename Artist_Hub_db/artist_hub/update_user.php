<?php
include "connect.php";

$id      = intval($_POST['id'] ?? 0);
$name    = trim($_POST['name'] ?? '');
$phone   = trim($_POST['phone'] ?? '');
$address = trim($_POST['address'] ?? '');

if($id <= 0) response(false,"Invalid user ID");
if($name == '') response(false,"Name is required");

if($phone != '' && !preg_match('/^[0-9]{10}$/',$phone)){
    response(false,"Phone number must be 10 digits");
}

/* check user exists */
$check = mysqli_query($conn,"
SELECT id FROM g_users WHERE id='$id' AND is_active=1
");

if(mysqli_num_rows($check) == 0){
    response(false,"User not found");
}

/* update */
$update = mysqli_query($conn,"
UPDATE g_users SET
name='$name',
phone='$phone',
address='$address'
WHERE id='$id'
");

if(!$update){
    response(false,"Update failed");
}

response(true,"User updated successfully");
