<?php
include "connect.php";

/* INPUT */
$booking_id  = intval($_POST['booking_id'] ?? 0);
$customer_id = intval($_POST['customer_id'] ?? 0);

/* VALIDATION */
if($booking_id <= 0) response(false,"Booking ID is required");
if($customer_id <= 0) response(false,"Customer ID is required");

/* check booking exists and belongs to customer */
$q = mysqli_query($conn,"SELECT * FROM g_bookings WHERE id='$booking_id' AND customer_id='$customer_id'");
if(mysqli_num_rows($q)==0) response(false,"Booking not found for this customer");

/* check booking status */
$booking = mysqli_fetch_assoc($q);
if($booking['status']=='cancelled') response(false,"Booking already cancelled");
if($booking['status']=='completed') response(false,"Cannot cancel completed booking");

/* cancel booking */
$update = mysqli_query($conn,"UPDATE g_bookings SET status='cancelled', cancelled_by='customer' WHERE id='$booking_id'");
if(!$update) response(false,"Failed to cancel booking");

/* fetch updated booking */
$q2 = mysqli_query($conn,"
SELECT b.*, c.name as customer_name, c.email as customer_email, a.name as artist_name, a.email as artist_email
FROM g_bookings b
JOIN g_users c ON b.customer_id=c.id
JOIN g_users a ON b.artist_id=a.id
WHERE b.id='$booking_id'
");
$updated = mysqli_fetch_assoc($q2);

response(true,"Booking cancelled by customer",$updated);
