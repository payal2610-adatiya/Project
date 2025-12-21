<?php
include "connect.php";

/* optional filters */
$artist_id   = intval($_GET['artist_id'] ?? 0);
$customer_id = intval($_GET['customer_id'] ?? 0);

$where = "1";
if($artist_id > 0) $where .= " AND r.artist_id='$artist_id'";
if($customer_id > 0) $where .= " AND r.customer_id='$customer_id'";

/* Fetch reviews with names */
$q = mysqli_query($conn,"
SELECT r.*, 
c.name as customer_name, c.email as customer_email,
a.name as artist_name, a.email as artist_email
FROM g_reviews r
JOIN g_users c ON r.customer_id=c.id
JOIN g_users a ON r.artist_id=a.id
WHERE $where
ORDER BY r.created_at DESC
");

$reviews = [];
while($row = mysqli_fetch_assoc($q)){
    $reviews[] = $row;
}

if(count($reviews)==0){
    response(true,"No reviews found",[]);
}else{
    response(true,"Reviews fetched successfully",$reviews);
}
