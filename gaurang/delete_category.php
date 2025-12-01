<?php
header('Content-Type: application/json');
include 'connect.php';
$data = json_decode(file_get_contents("php://input"), true);

if(!$data || !isset($data['category_id'])) {
    echo json_encode(["status"=>false,"message"=>"Missing category_id"]);
    exit;
}

$category_id = $data['category_id'];

try {
    $stmt = $con->prepare("DELETE FROM g_categories WHERE category_id = ?");
    $stmt->execute([$category_id]);
    echo json_encode(["status"=>true,"message"=>"Category deleted"]);
} catch(PDOException $e) {
    echo json_encode(["status"=>false,"message"=>$e->getMessage()]);
}
?>