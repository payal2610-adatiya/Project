<?php
include 'connect.php';
header('Content-Type: application/json');

$user_id = $_POST['user_id'] ?? '';

if (empty($user_id)) {
    echo json_encode(["status" => "error", "message" => "Missing user_id"]);
    exit;
}

$sql = "SELECT c.name AS category, c.type, SUM(t.amount) AS total
        FROM p_transaction t
        JOIN p_category c ON t.category_id = c.id
        WHERE t.user_id='$user_id'
        GROUP BY c.id";

$result = mysqli_query($con, $sql);
$data = [];

while ($row = mysqli_fetch_assoc($result)) {
    $data[] = $row;
}

echo json_encode(["status" => "success", "overview" => $data]);
?>
