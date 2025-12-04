<?php
include 'connect.php';
header('Content-Type: application/json');

$action = $_POST['action'] ?? '';

if (empty($action)) {
    echo json_encode(["status" => "error", "message" => "Missing action"]);
    exit;
}

switch ($action) {

    // 🧍 UPDATE USER
    case 'update_user':
        $id = $_POST['id'] ?? '';
        $name = $_POST['name'] ?? '';
        $email = $_POST['email'] ?? '';

        if (empty($id) || empty($name) || empty($email)) {
            echo json_encode(["status" => "error", "message" => "Missing required fields"]);
            exit;
        }

        $sql = "UPDATE p_users SET name='$name', email='$email' WHERE id='$id'";
        break;

    // 📂 UPDATE CATEGORY
    case 'update_category':
        $id = $_POST['id'] ?? '';
        $name = $_POST['name'] ?? '';
        $type = $_POST['type'] ?? '';

        if (empty($id) || empty($name) || empty($type)) {
            echo json_encode(["status" => "error", "message" => "Missing required fields"]);
            exit;
        }

        $sql = "UPDATE p_category SET name='$name', type='$type' WHERE id='$id'";
        break;

    // 💰 UPDATE TRANSACTION
    case 'update_transaction':
        $id = $_POST['id'] ?? '';
        $amount = $_POST['amount'] ?? '';
        $note = $_POST['note'] ?? '';
        $date = $_POST['date'] ?? '';
        $category_id = $_POST['category_id'] ?? '';

        if (empty($id) || empty($amount) || empty($date) || empty($category_id)) {
            echo json_encode(["status" => "error", "message" => "Missing required fields"]);
            exit;
        }

        $sql = "UPDATE p_transaction 
                SET amount='$amount', note='$note', date='$date', category_id='$category_id' 
                WHERE id='$id'";
        break;

    default:
        echo json_encode(["status" => "error", "message" => "Invalid action"]);
        exit;
}

if (mysqli_query($con, $sql)) {
    echo json_encode(["status" => "success", "message" => "Record updated successfully"]);
} else {
    echo json_encode(["status" => "error", "message" => "Update failed"]);
}
?>
