<?php
header('Content-Type: application/json');
include 'connect.php';
$data = json_decode(file_get_contents("php://input"), true);

if(!$data || !isset($data['artist_id'])) {
    echo json_encode(["status"=>false,"message"=>"Missing artist_id"]);
    exit;
}

$artist_id = $data['artist_id'];

try {
    $stmt = $con->prepare("DELETE FROM g_users WHERE user_id = ? AND role = 'artist'");
    $stmt->execute([$artist_id]);
    echo json_encode(["status"=>true,"message"=>"Artist deleted"]);
} catch(PDOException $e) {
    echo json_encode(["status"=>false,"message"=>$e->getMessage()]);
}
?>