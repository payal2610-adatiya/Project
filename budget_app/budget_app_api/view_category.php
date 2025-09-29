<?php
include('connect.php');

if (isset($_GET['type'])) {
    $type = $_GET['type'];
    $query = "SELECT * FROM category WHERE type='$type'";
} else {
    $query = "SELECT * FROM category";
}

$result = mysqli_query($con, $query);
$categories = [];

while ($row = mysqli_fetch_assoc($result)) {
    $categories[] = $row;
}

echo json_encode(["status" => "success", "categories" => $categories]);
?>
