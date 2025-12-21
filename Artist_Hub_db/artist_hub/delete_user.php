<?php
include "connect.php";

$id = intval($_POST['id'] ?? 0);

if($id <= 0){
    response(false,"Invalid user ID");
}

/* check user exists */
$check = mysqli_query($conn,"
SELECT id FROM g_users WHERE id='$id' AND is_active=1
");

if(mysqli_num_rows($check) == 0){
    response(false,"User not found or already deleted");
}

/* soft delete */
$delete = mysqli_query($conn,"
UPDATE g_users SET is_active=0 WHERE id='$id'
");

if(!$delete){
    response(false,"Delete failed");
}

response(true,"User deleted successfully");
