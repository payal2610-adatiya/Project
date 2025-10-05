<?php
include('connect.php');
header('Content-Type: application/json');

// Fetch all transactions
$res = mysqli_query($con,"
    SELECT t.id, t.amount, t.date, t.note, c.name AS category_name, c.type AS category_type
    FROM p_transaction t
    JOIN p_category c ON t.category_id = c.id
    ORDER BY t.date DESC
");

$transactions = [];
while($row = mysqli_fetch_assoc($res)){
    $transactions[] = $row;
}

echo json_encode(['code'=>200, 'transactions'=>$transactions]);
?>
