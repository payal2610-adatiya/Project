<?php
include('connect.php');

$query = "SELECT * FROM transactions ORDER BY date DESC";
$result = mysqli_query($con, $query);

$transactions = [];
while ($row = mysqli_fetch_assoc($result)) {
    $transactions[] = $row;
}

echo json_encode(["status" => "success", "transactions" => $transactions]);
?>
