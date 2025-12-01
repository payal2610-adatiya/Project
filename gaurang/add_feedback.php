<?php
header('Content-Type: application/json');
include 'connect.php'; // MySQLi connection

$data = json_decode(file_get_contents("php://input"), true);

// Validate required fields
if (!$data || !isset($data['user_id'], $data['message'])) {
    echo json_encode(["status" => false, "message" => "Missing required fields"]);
    exit;
}

$user_id = $data['user_id'];
$message = $data['message'];

// Insert feedback
$stmt = mysqli_prepare($con, "INSERT INTO g_feedbacks (user_id, message) VALUES (?, ?)");
mysqli_stmt_bind_param($stmt, "is", $user_id, $message);

if (mysqli_stmt_execute($stmt)) {
    $feedback_id = mysqli_insert_id($con);
    echo json_encode(["status" => true, "message" => "Feedback added", "feedback_id" => $feedback_id]);
} else {
    echo json_encode(["status" => false, "message" => mysqli_error($con)]);
}

// Close connection
mysqli_close($con);
?>
