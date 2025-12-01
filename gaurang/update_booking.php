<?php
header('Content-Type: application/json');
include 'connect.php';
$data = json_decode(file_get_contents("php://input"), true);

if(!$data || !isset($data['booking_id'])) {
    echo json_encode(["status"=>false,"message"=>"Missing booking_id"]);
    exit;
}

$booking_id = $data['booking_id'];
$event_date = $data['event_date'] ?? null;
$event_time = $data['event_time'] ?? null;
$location = $data['location'] ?? null;
$status = $data['status'] ?? null;

try {
    $stmt = $con->prepare("UPDATE g_bookings SET event_date = COALESCE(?, event_date), event_time = COALESCE(?, event_time), location = COALESCE(?, location), status = COALESCE(?, status) WHERE booking_id = ?");
    $stmt->execute([$event_date,$event_time,$location,$status,$booking_id]);
    echo json_encode(["status"=>true,"message"=>"Booking updated"]);
} catch(PDOException $e) {
    echo json_encode(["status"=>false,"message"=>$e->getMessage()]);
}
?>