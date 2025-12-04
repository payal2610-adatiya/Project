<?php
include('connect.php');
header('Content-Type: application/json');


$user_id = $_REQUEST['user_id'] ?? '';
$name = $_REQUEST['name'] ?? '';
$type = $_REQUEST['type'] ?? '';

if(empty($user_id) || empty($name) || empty($type)){
    echo json_encode(['code'=>400,'message'=>'All fields required']);
    exit;
}

// Check if user exists
$user_check = mysqli_query($con,"SELECT id FROM p_users WHERE id='$user_id'");
if(mysqli_num_rows($user_check) == 0){
    echo json_encode(['code'=>404,'message'=>'User not found']);
    exit;
}

// Insert category
mysqli_query($con,"INSERT INTO p_category(user_id,name,type) VALUES('$user_id','$name','$type')");
echo json_encode(['code'=>200,'message'=>'Category added successfully']);
?>
