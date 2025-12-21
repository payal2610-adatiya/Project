<?php
include "connect.php";

/* INPUTS: optional filter by booking_id, customer_id, artist_id */
$booking_id  = intval($_GET['booking_id'] ?? 0);
$customer_id = intval($_GET['customer_id'] ?? 0);
$artist_id   = intval($_GET['artist_id'] ?? 0);

/* BUILD QUERY */
$sql = "
SELECT b.*, 
c.name as customer_name, c.email as customer_email, c.phone as customer_phone,
a.name as artist_name, a.email as artist_email
FROM g_bookings b
JOIN g_users c ON b.customer_id=c.id
JOIN g_users a ON b.artist_id=a.id
WHERE 1=1
";

/* ADD FILTERS */
if($booking_id > 0){
    $sql .= " AND b.id='$booking_id'";
}
if($customer_id > 0){
    $sql .= " AND b.customer_id='$customer_id'";
}
if($artist_id > 0){
    $sql .= " AND b.artist_id='$artist_id'";
}

/* EXECUTE QUERY */
$q = mysqli_query($conn,$sql);
if(!$q) response(false,"Failed to fetch bookings");

/* FETCH RESULTS */
$bookings = [];
while($row = mysqli_fetch_assoc($q)){
    $bookings[] = $row;
}

/* RESPONSE */
if(count($bookings) == 0){
    response(true,"No bookings found",[]);
} else {
    response(true,"Bookings fetched successfully",$bookings);
}
