<?php
header('Content-Type: application/json');
include 'connect.php';
$data = json_decode(file_get_contents("php://input"), true);

if(!$data || !isset($data['name'], $data['email'], $data['password'])) {
    echo json_encode(["status"=>false,"message"=>"Missing required fields"]);
    exit;
}

$name = $data['name'];
$email = $data['email'];
$password_hashed = password_hash($data['password'], PASSWORD_BCRYPT);
$phone = $data['phone'] ?? null;
$address = $data['address'] ?? null;
$role = $data['role'] ?? 'customer';
$profile_pic = $data['profile_pic'] ?? null;

try {
    $stmt = $con->prepare("INSERT INTO g_users (name,email,password,phone,address,role,profile_pic) VALUES (?,?,?,?,?,?,?)");
    $stmt->execute([$name,$email,$password_hashed,$phone,$address,$role,$profile_pic]);
    echo json_encode(["status"=>true,"message"=>"User registered successfully","user_id"=>$con->lastInsertId()]);
} catch(PDOException $e) {
    echo json_encode(["status"=>false,"message"=>"Registration failed: ".$e->getMessage()]);
}
?>