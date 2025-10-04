<?php
include('connect.php');

// Fetch all users
$res = mysqli_query($con, "SELECT id, name, email, created_at FROM p_users");

$users = [];
while($row = mysqli_fetch_assoc($res)){
    $users[] = $row;
}

echo json_encode(['code'=>200, 'users'=>$users]);
?>
