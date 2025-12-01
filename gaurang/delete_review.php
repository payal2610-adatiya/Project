<?php
header('Content-Type: application/json');
include 'connect.php';
$data = json_decode(file_get_contents("php://input"), true);

if(!$data || !isset($data['review_id'])) {
    echo json_encode(["status"=>false,"message"=>"Missing review_id"]);
    exit;
}

$review_id = $data['review_id'];

try {
    $stmt = $con->prepare("DELETE FROM g_reviews WHERE review_id = ?");
    $stmt->execute([$review_id]);
    echo json_encode(["status"=>true,"message"=>"Review deleted"]);
} catch(PDOException $e) {
    echo json_encode(["status"=>false,"message"=>$e->getMessage()]);
}
?>