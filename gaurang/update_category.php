<?php
header('Content-Type: application/json');
include 'connect.php';
$data = json_decode(file_get_contents("php://input"), true);

if(!$data || !isset($data['category_id'])) {
    echo json_encode(["status"=>false,"message"=>"Missing category_id"]);
    exit;
}

$category_id = $data['category_id'];
$name = $data['name'] ?? null;
$description = $data['description'] ?? null;

try {
    $stmt = $con->prepare("UPDATE g_categories SET name = COALESCE(?, name), description = COALESCE(?, description) WHERE category_id = ?");
    $stmt->execute([$name,$description,$category_id]);
    echo json_encode(["status"=>true,"message"=>"Category updated"]);
} catch(PDOException $e) {
    echo json_encode(["status"=>false,"message"=>$e->getMessage()]);
}
?>