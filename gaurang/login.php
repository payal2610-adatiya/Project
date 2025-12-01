<?php
header('Content-Type: application/json');
include 'connect.php';
$data = json_decode(file_get_contents("php://input"), true);

if(!$data || !isset($data['email'], $data['password'])) {
    echo json_encode(["status"=>false,"message"=>"Missing email or password"]);
    exit;
}

$email = $data['email'];
$password = $data['password'];

try {
    $stmt = $con->prepare("SELECT * FROM g_users WHERE email = ?");
    $stmt->execute([$email]);
    $user = $stmt->fetch(PDO::FETCH_ASSOC);
    if($user && password_verify($password, $user['password'])) {
        unset($user['password']);
        echo json_encode(["status"=>true,"user"=>$user]);
    } else {
        echo json_encode(["status"=>false,"message"=>"Invalid email or password"]);
    }
} catch(PDOException $e) {
    echo json_encode(["status"=>false,"message"=>$e->getMessage()]);
}
?>