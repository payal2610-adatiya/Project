<?php
header('Content-Type: application/json');
include 'connect.php'; // MySQLi connection

$artist_id = isset($_GET['artist_id']) ? $_GET['artist_id'] : null;

if ($artist_id) {
    $stmt = mysqli_prepare($con, "SELECT * FROM g_artist_media WHERE artist_id = ?");
    mysqli_stmt_bind_param($stmt, "i", $artist_id);
    mysqli_stmt_execute($stmt);
    $result = mysqli_stmt_get_result($stmt);
} else {
    $result = mysqli_query($con, "SELECT * FROM g_artist_media");
}

if ($result) {
    $media = mysqli_fetch_all($result, MYSQLI_ASSOC);
    echo json_encode(["status" => true, "media" => $media]);
} else {
    echo json_encode(["status" => false, "message" => mysqli_error($con)]);
}

// Close connection
mysqli_close($con);
?>
