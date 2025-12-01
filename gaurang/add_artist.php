<?php
header('Content-Type: application/json');
include 'connect.php'; // MySQLi connection

$data = json_decode(file_get_contents("php://input"), true);

// Validate required fields
if (!$data || !isset($data['name'], $data['email'], $data['password'])) {
    echo json_encode(["status" => false, "message" => "Missing required fields"]);
    exit;
}

$name = $data['name'];
$email = $data['email'];
$password_hashed = password_hash($data['password'], PASSWORD_BCRYPT);
$phone = $data['phone'] ?? null;
$address = $data['address'] ?? null;
$role = 'artist';
$profile_pic = $data['profile_pic'] ?? null;
$categories = $data['categories'] ?? []; // array of category_ids

// Start transaction
mysqli_begin_transaction($con);

try {
    // Insert into g_users
    $stmt = mysqli_prepare($con, "INSERT INTO g_users (name, email, password, phone, address, role, profile_pic) VALUES (?, ?, ?, ?, ?, ?, ?)");
    mysqli_stmt_bind_param($stmt, "sssssss", $name, $email, $password_hashed, $phone, $address, $role, $profile_pic);
    mysqli_stmt_execute($stmt);

    $artist_id = mysqli_insert_id($con); // Get last inserted ID

    // Insert categories if provided
    if (!empty($categories)) {
        $stmt2 = mysqli_prepare($con, "INSERT INTO g_artist_category (artist_id, category_id) VALUES (?, ?)");
        foreach ($categories as $cat_id) {
            mysqli_stmt_bind_param($stmt2, "ii", $artist_id, $cat_id);
            mysqli_stmt_execute($stmt2);
        }
    }

    // Commit transaction
    mysqli_commit($con);

    echo json_encode(["status" => true, "message" => "Artist added", "artist_id" => $artist_id]);
} catch (Exception $e) {
    mysqli_rollback($con); // Rollback transaction on error
    echo json_encode(["status" => false, "message" => $e->getMessage()]);
}

// Close connection
mysqli_close($con);
?>
