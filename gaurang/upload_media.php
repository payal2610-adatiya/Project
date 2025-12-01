<?php
header('Content-Type: application/json');
include 'connect.php';
$data = json_decode(file_get_contents("php://input"), true);

if(!$data || !isset($data['artist_id'], $data['media_url'], $data['media_type'])) {
    echo json_encode(["status"=>false,"message"=>"Missing required fields"]);
    exit;
}

$artist_id = $data['artist_id'];
$media_url = $data['media_url'];
$media_type = $data['media_type']; // expected 'image' or 'video'

if(!in_array($media_type, ['image','video'])) {
    echo json_encode(["status"=>false,"message"=>"Invalid media_type"]);
    exit;
}

try {
    $stmt = $con->prepare("INSERT INTO g_artist_media (artist_id, media_url, media_type) VALUES (?,?,?)");
    $stmt->execute([$artist_id, $media_url, $media_type]);
    echo json_encode(["status"=>true,"message"=>"Media uploaded","media_id"=>$con->lastInsertId()]);
} catch(PDOException $e) {
    echo json_encode(["status"=>false,"message"=>$e->getMessage()]);
}
?>