<?php
header('Content-Type: application/json');
include 'connect.php'; // MySQLi connection

$data = json_decode(file_get_contents("php://input"), true);

// Validate required fields
if (!$data || !isset($data['customer_id'], $data['artist_id'], $data['event_date'])) {
    echo json_encode(["status" => false, "message" => "Missing required fields"]);
    exit;
}

$customer_id = $data['customer_id'];
$artist_id = $data['artist_id'];
$event_date = $data['event_date']; // YYYY-MM-DD
$event_time = $data['event_time'] ?? null; // HH:MM:SS (optional)
$location = $data['location'] ?? null;

// Insert booking
$stmt = mysqli_prepare($con, "INSERT INTO g_bookings (customer_id, artist_id, event_date, event_time, location) VALUES (?, ?, ?, ?, ?)");
mysqli_stmt_bind_param($stmt, "iisss", $customer_id, $artist_id, $event_date, $event_time, $location);

if (mysqli_stmt_execute($stmt)) {
    $booking_id = mysqli_insert_id($con);
    echo json_encode(["status" => true, "message" => "Booking created", "booking_id" => $booking_id]);
} else {
    echo json_encode(["status" => false, "message" => mysqli_error($con)]);
}

// Close connection
mysqli_close($con);
?>
