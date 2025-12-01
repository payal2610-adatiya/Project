<?php
header('Content-Type: application/json');
include 'connect.php'; // MySQLi connection

$data = json_decode(file_get_contents("php://input"), true);

// Validate required fields
if (!$data || !isset($data['booking_id'], $data['customer_id'], $data['artist_id'], $data['rating'])) {
    echo json_encode(["status" => false, "message" => "Missing required fields"]);
    exit;
}

$booking_id = $data['booking_id'];
$customer_id = $data['customer_id'];
$artist_id = $data['artist_id'];
$rating = (int)$data['rating'];
$comment = $data['comment'] ?? null;

// Validate rating
if ($rating < 1 || $rating > 5) {
    echo json_encode(["status" => false, "message" => "Rating must be between 1 and 5"]);
    exit;
}

// Insert review
$stmt = mysqli_prepare($con, "INSERT INTO g_reviews (booking_id, customer_id, artist_id, rating, comment) VALUES (?, ?, ?, ?, ?)");
mysqli_stmt_bind_param($stmt, "iiiis", $booking_id, $customer_id, $artist_id, $rating, $comment);

if (mysqli_stmt_execute($stmt)) {
    $review_id = mysqli_insert_id($con);
    echo json_encode(["status" => true, "message" => "Review added", "review_id" => $review_id]);
} else {
    echo json_encode(["status" => false, "message" => mysqli_error($con)]);
}

// Close connection
mysqli_close($con);
?>
