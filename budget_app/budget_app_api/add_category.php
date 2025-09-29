<?php
include('connect.php');

if (isset($_POST['name']) && isset($_POST['type'])) {
    $name = $_POST['name'];
    $type = $_POST['type'];

    $query = "INSERT INTO category(name,type) VALUES('$name','$type')";
    if (mysqli_query($con, $query)) {
        echo json_encode(["status" => "success", "message" => "Category added"]);
    } else {
        echo json_encode(["status" => "error", "message" => mysqli_error($con)]);
    }
} else {
    echo json_encode(["status" => "error", "message" => "Missing parameters"]);
}
?>
