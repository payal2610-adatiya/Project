<?php
include('connect.php');
header('Content-Type: application/json');

$user_id = $_REQUEST['user_id'] ?? '';
$category_id = $_REQUEST['category_id'] ?? '';
$amount = $_REQUEST['amount'] ?? '';
$date = $_REQUEST['date'] ?? '';
$note = $_REQUEST['note'] ?? '';

if(empty($user_id) || empty($category_id) || empty($amount) || empty($date)){
    echo json_encode(['code'=>400,'message'=>'All fields required']);
    exit;
}

// Check if user exists
$user_check = mysqli_query($con,"SELECT id FROM p_users WHERE id='$user_id'");
if(mysqli_num_rows($user_check) == 0){
    echo json_encode(['code'=>404,'message'=>'User not found']);
    exit;
}

// Check if category exists
$cat_check = mysqli_query($con,"SELECT id FROM p_category WHERE id='$category_id' AND user_id='$user_id'");
if(mysqli_num_rows($cat_check) == 0){
    echo json_encode(['code'=>404,'message'=>'Category not found for this user']);
    exit;
}

// Insert transaction
mysqli_query($con,"INSERT INTO p_transaction(user_id,category_id,amount,date,note) VALUES('$user_id','$category_id','$amount','$date','$note')");
echo json_encode(['code'=>200,'message'=>'Transaction added successfully']);
?>
