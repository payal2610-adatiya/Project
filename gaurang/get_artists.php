<?php
header('Content-Type: application/json');
include 'connect.php'; // MySQLi connection

$sql = "
    SELECT u.user_id, u.name, u.email, u.phone, u.address, u.profile_pic, u.status, u.created_at,
           GROUP_CONCAT(ac.category_id) AS category_ids
    FROM g_users u
    LEFT JOIN g_artist_category ac ON u.user_id = ac.artist_id
    WHERE u.role = 'artist'
    GROUP BY u.user_id
";

$result = mysqli_query($con, $sql);

if ($result) {
    $artists = mysqli_fetch_all($result, MYSQLI_ASSOC); // Fetch all rows as associative array
    echo json_encode(["status" => true, "artists" => $artists]);
} else {
    echo json_encode(["status" => false, "message" => mysqli_error($con)]);
}

// Close the connection
mysqli_close($con);
?>
