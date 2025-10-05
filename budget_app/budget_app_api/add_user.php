<?php
include('connect.php');
header('Content-Type: application/json');

$name = $_REQUEST['name'] ?? '';
$email = $_REQUEST['email'] ?? '';
$password = $_REQUEST['password'] ?? '';

if(empty($name) || empty($email) || empty($password)){
    echo json_encode(['code'=>400,'message'=>'All fields required']);
    exit;
}

$check = mysqli_query($con,"SELECT * FROM p_users WHERE email='$email'");
if(mysqli_num_rows($check) > 0){
    echo json_encode(['code'=>409,'message'=>'Email already exists']);
    exit;
}

mysqli_query($con,"INSERT INTO p_users(name,email,password) VALUES('$name','$email','$password')");
echo json_encode(['code'=>200,'message'=>'User added successfully']);
?>
