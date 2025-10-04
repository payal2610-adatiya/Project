<?php
include('connect.php');

// Total users
$user_count_res = mysqli_query($con, "SELECT COUNT(*) AS total_users FROM p_users");
$total_users = mysqli_fetch_assoc($user_count_res)['total_users'];

// Total categories
$cat_count_res = mysqli_query($con, "SELECT COUNT(*) AS total_categories FROM p_category");
$total_categories = mysqli_fetch_assoc($cat_count_res)['total_categories'];

// Total transactions
$trans_count_res = mysqli_query($con, "SELECT COUNT(*) AS total_transactions FROM p_transaction");
$total_transactions = mysqli_fetch_assoc($trans_count_res)['total_transactions'];

// Fetch all users for admin to delete if needed
$user_res = mysqli_query($con, "SELECT id, name, email, created_at FROM p_users ORDER BY id DESC");
$users = [];
while($row = mysqli_fetch_assoc($user_res)){
    $users[] = $row;
}

// Return JSON
echo json_encode([
    'code' => 200,
    'total_users' => intval($total_users),
    'total_categories' => intval($total_categories),
    'total_transactions' => intval($total_transactions),
    'users' => $users
]);
?>
 