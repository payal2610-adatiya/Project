<?php
header('Content-Type: application/json');
include 'connect.php';
$data = json_decode(file_get_contents("php://input"), true);

if(!$data || !isset($data['booking_id'])) {
    echo json_encode(["status"=>false,"message"=>"Missing booking_id"]);
    exit;
}

$booking_id = $data['booking_id'];

try {
    $stmt = $con->prepare("DELETE FROM g_bookings WHERE booking_id = ?");
    $stmt->execute([$booking_id]);
    echo json_encode(["status"=>true,"message"=>"Booking deleted"]);
} catch(PDOException $e) {
    echo json_encode(["status"=>false,"message"=>$e->getMessage()]);
}
?>