<?php
include('connect.php');

$user_id = $_REQUEST['user_id'] ?? '';
$month = $_REQUEST['month'] ?? date('Y-m');

if(empty($user_id)){
    echo json_encode(['code'=>400,'message'=>'User ID required']);
    exit;
}

// Fetch transactions
$res = mysqli_query($con,"
SELECT t.id, t.amount, t.date, t.note, c.name AS category_name, c.type AS category_type
FROM p_transaction t
JOIN p_category c ON t.category_id=c.id
WHERE t.user_id='$user_id' AND DATE_FORMAT(t.date,'%Y-%m')='$month'
ORDER BY t.date DESC
");

$transactions = [];
while($row = mysqli_fetch_assoc($res)){
    $transactions[] = $row;
}

echo json_encode(['code'=>200,'transactions'=>$transactions]);
?>
