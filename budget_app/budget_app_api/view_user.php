<?php
include('connect.php');

$query = "SELECT * FROM users ";
$result = mysqli_query($con, $query);

$transactions = [];
while ($row = mysqli_fetch_assoc($result)) {
    $transactions[] = $row;
}

echo json_encode(["status" => "success", "users" => $transactions]);
?>
