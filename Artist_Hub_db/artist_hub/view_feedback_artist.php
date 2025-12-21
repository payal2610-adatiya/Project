<?php
include "connect.php";

/* INPUT: Artist ID */
$artist_id = intval($_GET['artist_id'] ?? 0);
if($artist_id <= 0) response(false,"Artist ID is required");

/* Check artist exists */
$q = mysqli_query($conn,"SELECT id,name FROM g_users WHERE id='$artist_id' AND role='artist' AND is_active=1");
if(mysqli_num_rows($q) == 0) response(false,"Artist not found");

/* Fetch feedbacks given by customers to this artist */
$q2 = mysqli_query($conn,"
SELECT r.id as review_id, r.rating, r.comment, r.created_at,
b.id as booking_id, c.id as customer_id, c.name as customer_name, c.email as customer_email
FROM g_reviews r
JOIN g_bookings b ON r.booking_id = b.id
JOIN g_users c ON r.customer_id = c.id
WHERE r.artist_id = '$artist_id'
ORDER BY r.created_at DESC
");

$feedbacks = [];
while($row = mysqli_fetch_assoc($q2)){
    $feedbacks[] = $row;
}

if(count($feedbacks) == 0){
    response(true,"No feedback found for this artist",[]);
}else{
    response(true,"Feedback fetched successfully",$feedbacks);
}
