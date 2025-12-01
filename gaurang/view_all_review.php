<?php
header('Content-Type: application/json');
include 'connect.php'; // MySQLi connection

$sql = "SELECT * FROM g_reviews";
$result = mysqli_query($con, $sql);

if ($result) {
    $reviews = mysqli_fetch_all($result, MYSQLI_ASSOC); // Fetch all rows as associative array
    echo json_encode(["status" => true, "reviews" => $reviews]);
} else {
    echo json_encode(["status" => false, "message" => mysqli_error($con)]);
}

// Close the connection
mysqli_close($con);
?>
