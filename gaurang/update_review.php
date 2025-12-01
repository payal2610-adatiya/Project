<?php
header('Content-Type: application/json');
include 'connect.php';
$data = json_decode(file_get_contents("php://input"), true);

if(!$data || !isset($data['review_id'])) {
    echo json_encode(["status"=>false,"message"=>"Missing review_id"]);
    exit;
}

$review_id = $data['review_id'];
$rating = isset($data['rating']) ? (int)$data['rating'] : null;
$comment = $data['comment'] ?? null;

if($rating !== null && ($rating < 1 || $rating > 5)) {
    echo json_encode(["status"=>false,"message"=>"Rating must be between 1 and 5"]);
    exit;
}

try {
    $stmt = $con->prepare("UPDATE g_reviews SET rating = COALESCE(?, rating), comment = COALESCE(?, comment) WHERE review_id = ?");
    $stmt->execute([$rating,$comment,$review_id]);
    echo json_encode(["status"=>true,"message"=>"Review updated"]);
} catch(PDOException $e) {
    echo json_encode(["status"=>false,"message"=>$e->getMessage()]);
}
?>