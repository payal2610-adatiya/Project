<?php
header('Content-Type: application/json');
include 'connect.php'; // MySQLi connection

$data = json_decode(file_get_contents("php://input"), true);

// Validate required fields
if (!$data || !isset($data['name'])) {
    echo json_encode(["status" => false, "message" => "Missing category name"]);
    exit;
}

$name = $data['name'];
$description = $data['description'] ?? null;

// Insert category
$stmt = mysqli_prepare($con, "INSERT INTO g_categories (name, description) VALUES (?, ?)");
mysqli_stmt_bind_param($stmt, "ss", $name, $description);

if (mysqli_stmt_execute($stmt)) {
    $category_id = mysqli_insert_id($con);
    echo json_encode(["status" => true, "message" => "Category added", "category_id" => $category_id]);
} else {
    echo json_encode(["status" => false, "message" => mysqli_error($con)]);
}

// Close connection
mysqli_close($con);
?>
