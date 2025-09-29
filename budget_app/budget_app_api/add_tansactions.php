<?php
include('connect.php');

if (isset($_POST['type']) && isset($_POST['title']) && isset($_POST['amount']) && isset($_POST['date']) && isset($_POST['category'])) {
    $type = $_POST['type'];
    $title = $_POST['title'];
    $desc = $_POST['description'] ?? '';
    $amount = $_POST['amount'];
    $date = $_POST['date'];
    $category = $_POST['category'];

    $query = "INSERT INTO transactions(type,title,description,amount,date,category) 
              VALUES('$type','$title','$desc','$amount','$date','$category')";
    if (mysqli_query($con, $query)) {
        echo json_encode(["status" => "success", "message" => "Transaction added"]);
    } else {
        echo json_encode(["status" => "error", "message" => mysqli_error($con)]);
    }
} else {
    echo json_encode(["status" => "error", "message" => "Missing parameters"]);
}
?>
