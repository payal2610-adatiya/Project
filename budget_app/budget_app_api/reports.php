<?php
include 'connect.php';
header('Content-Type: application/json');

$user_id = $_POST['user_id'] ?? '';

if (empty($user_id)) {
    echo json_encode(["status" => "error", "message" => "Missing user_id"]);
    exit;
}

$sql_income = "SELECT SUM(t.amount) AS total_income
               FROM p_transaction t
               JOIN p_category c ON t.category_id = c.id
               WHERE t.user_id='$user_id' AND c.type='income'";

$sql_expense = "SELECT SUM(t.amount) AS total_expense
                FROM p_transaction t
                JOIN p_category c ON t.category_id = c.id
                WHERE t.user_id='$user_id' AND c.type='expense'";

$income = mysqli_fetch_assoc(mysqli_query($con, $sql_income))['total_income'] ?? 0;
$expense = mysqli_fetch_assoc(mysqli_query($con, $sql_expense))['total_expense'] ?? 0;

echo json_encode([
    "status" => "success",
    "income" => $income ?? 0,
    "expense" => $expense ?? 0,
    "balance" => ($income ?? 0) - ($expense ?? 0)
]);
?>
