<?php
include('connect.php');

$transaction_id = $_REQUEST['transaction_id'] ?? '';

if(empty($transaction_id)){
    echo json_encode(['code'=>400,'message'=>'Transaction ID required']);
    exit;
}

// Delete transaction
$res = mysqli_query($con,"DELETE FROM p_transaction WHERE id='$transaction_id'");

if($res){
    echo json_encode(['code'=>200,'message'=>'Transaction deleted successfully']);
}else{
    echo json_encode(['code'=>500,'message'=>'Failed to delete transaction']);
}
?>
