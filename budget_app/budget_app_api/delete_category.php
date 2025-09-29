<?php
include('connect.php');

if (isset($_GET['id'])) {
    $id = $_GET['id'];
    $query = "DELETE FROM category WHERE id='$id'";
    if (mysqli_query($con, $query)) {
        echo json_encode(["status" => "success", "message" => "Category deleted"]);
    } else {
        echo json_encode(["status" => "error", "message" => mysqli_error($con)]);
    }
} else {
    echo json_encode(["status" => "error", "message" => "Missing id"]);
}
?>
