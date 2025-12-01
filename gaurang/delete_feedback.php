<?php
header('Content-Type: application/json');
include 'connect.php';
$data = json_decode(file_get_contents("php://input"), true);

if(!$data || !isset($data['feedback_id'])) {
    echo json_encode(["status"=>false,"message"=>"Missing feedback_id"]);
    exit;
}

$feedback_id = $data['feedback_id'];

try {
    $stmt = $con->prepare("DELETE FROM g_feedbacks WHERE feedback_id = ?");
    $stmt->execute([$feedback_id]);
    echo json_encode(["status"=>true,"message"=>"Feedback deleted"]);
} catch(PDOException $e) {
    echo json_encode(["status"=>false,"message"=>$e->getMessage()]);
}
?>