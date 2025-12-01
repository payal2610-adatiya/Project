<?php
header('Content-Type: application/json');
include 'connect.php';
$data = json_decode(file_get_contents("php://input"), true);

if(!$data || !isset($data['media_id'])) {
    echo json_encode(["status"=>false,"message"=>"Missing media_id"]);
    exit;
}

$media_id = $data['media_id'];

try {
    $stmt = $con->prepare("DELETE FROM g_artist_media WHERE media_id = ?");
    $stmt->execute([$media_id]);
    echo json_encode(["status"=>true,"message"=>"Media deleted"]);
} catch(PDOException $e) {
    echo json_encode(["status"=>false,"message"=>$e->getMessage()]);
}
?>