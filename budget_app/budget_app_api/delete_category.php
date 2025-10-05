<?php
include('connect.php');
header('Content-Type: application/json');

$category_id = $_GET['id'] ?? ''; // Get ID from URL

if(empty($category_id)){
    echo json_encode(['code'=>400,'message'=>'Category ID required']);
    exit;
}

// Delete category
$res = mysqli_query($con,"DELETE FROM p_category WHERE id='$category_id'");

if($res){
    echo json_encode(['code'=>200,'message'=>'Category deleted successfully']);
}else{
    echo json_encode(['code'=>500,'message'=>'Failed to delete category']);
}
?>
