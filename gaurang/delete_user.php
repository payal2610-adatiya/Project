<?php
header('Content-Type: application/json');
include 'connect.php';
$data = json_decode(file_get_contents("php://input"), true);

if(!$data || !isset($data['user_id'])) {
    echo json_encode(["status"=>false,"message"=>"Missing user_id"]);
    exit;
}

$user_id = $data['user_id'];

try {
    $stmt = $con->prepare("DELETE FROM g_users WHERE user_id = ?");
    $stmt->execute([$user_id]);
    echo json_encode(["status"=>true,"message"=>"User deleted"]);
} catch(PDOException $e) {
    echo json_encode(["status"=>false,"message"=>$e->getMessage()]);
}
?>