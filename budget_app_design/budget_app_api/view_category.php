<?php
include('connect.php');
header('Content-Type: application/json');

$user_id = $_REQUEST['user_id'] ?? '';

if(empty($user_id)){
    echo json_encode(['code'=>400,'message'=>'User ID required']);
    exit;
}

// Check if user exists
$user_check = mysqli_query($con,"SELECT id FROM p_users WHERE id='$user_id'");
if(mysqli_num_rows($user_check) == 0){
    echo json_encode(['code'=>404,'message'=>'User not found']);
    exit;
}

// Fetch categories
$res = mysqli_query($con,"SELECT id,name,type,created_at FROM p_category WHERE user_id='$user_id'");
$categories = [];
while($row = mysqli_fetch_assoc($res)){
    $categories[] = $row;
}

echo json_encode(['code'=>200,'categories'=>$categories]);
?>
