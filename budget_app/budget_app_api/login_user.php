<?php
include('connect.php');
header('Content-Type: application/json');

$email = $_POST['email'] ?? '';
$password = $_POST['password'] ?? '';

if (empty($email) || empty($password)) {
    echo json_encode(['code'=>400, 'message'=>'Email and password required']);
    exit;
}

// ✅ Check user
$result = mysqli_query($con, "SELECT * FROM p_users WHERE email='$email' AND password='$password'");
if (mysqli_num_rows($result) > 0) {
    $user = mysqli_fetch_assoc($result);
    echo json_encode(['code'=>200, 'message'=>'Login successful', 'user'=>$user]);
} else {
    echo json_encode(['code'=>401, 'message'=>'Invalid email or password']);
}
?>
