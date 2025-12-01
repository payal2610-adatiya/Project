<?php
header('Content-Type: application/json');
include 'connect.php';
$data = json_decode(file_get_contents("php://input"), true);

if(!$data || !isset($data['user_id'])) {
    echo json_encode(["status"=>false,"message"=>"Missing user_id"]);
    exit;
}

$user_id = $data['user_id'];
$name = $data['name'] ?? null;
$phone = $data['phone'] ?? null;
$address = $data['address'] ?? null;
$status = $data['status'] ?? null;
$profile_pic = $data['profile_pic'] ?? null;

try {
    $stmt = $con->prepare("UPDATE g_users SET name = COALESCE(?, name), phone = COALESCE(?, phone), address = COALESCE(?, address), status = COALESCE(?, status), profile_pic = COALESCE(?, profile_pic) WHERE user_id = ?");
    $stmt->execute([$name,$phone,$address,$status,$profile_pic,$user_id]);
    echo json_encode(["status"=>true,"message"=>"User updated"]);
} catch(PDOException $e) {
    echo json_encode(["status"=>false,"message"=>$e->getMessage()]);
}
?>