<?php
include('connect.php');


$user_id = $_REQUEST['user_id'] ?? '';

if(empty($user_id)){
    echo json_encode(['code'=>400,'message'=>'User ID required']);
    exit;
}

// Delete user
$res = mysqli_query($con,"DELETE FROM p_users WHERE id='$user_id'");

// Check if a row was actually deleted
if($res && mysqli_affected_rows($con) > 0){
    echo json_encode(['code'=>200,'message'=>'User deleted successfully']);
}else{
    echo json_encode(['code'=>404,'message'=>'User not found or could not be deleted']);
}
?>
