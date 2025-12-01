<?php
header('Content-Type: application/json');
include 'connect.php'; // MySQLi connection

$sql = "SELECT user_id, name, email, phone, address, role, profile_pic, status, created_at FROM g_users";
$result = mysqli_query($con, $sql);

if ($result) {
    $users = mysqli_fetch_all($result, MYSQLI_ASSOC); // Fetch all rows as associative array
    echo json_encode(["status" => true, "users" => $users]);
} else {
    echo json_encode(["status" => false, "message" => mysqli_error($con)]);
}

// Close the connection
mysqli_close($con);
?>
