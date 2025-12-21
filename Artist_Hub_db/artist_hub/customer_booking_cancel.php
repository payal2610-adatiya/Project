<?php
include "connect.php";

/* INPUTS */
$booking_id    = intval($_POST['booking_id'] ?? 0);
$customer_id   = intval($_POST['customer_id'] ?? 0);
$cancel_reason = trim($_POST['cancel_reason'] ?? '');

/* VALIDATION */
if($booking_id <= 0) response(false,"Booking ID is required");
if($customer_id <= 0) response(false,"Customer ID is required");
if($cancel_reason == '') response(false,"Cancel reason is required");

/* CHECK BOOKING EXISTS AND BELONGS TO CUSTOMER */
$q = mysqli_query($conn,"SELECT * FROM g_bookings WHERE id='$booking_id' AND customer_id='$customer_id'");
if(mysqli_num_rows($q) == 0) response(false,"Booking not found for this customer");

$booking = mysqli_fetch_assoc($q);

/* Check booking status */
if($booking['status']=='cancelled') response(false,"Booking already cancelled");
if($booking['status']=='completed') response(false,"Cannot cancel completed booking");

/* UPDATE BOOKING STATUS */
$update = mysqli_query($conn,"
UPDATE g_bookings 
SET status='cancelled', cancelled_by='customer', cancel_reason='$cancel_reason'
WHERE id='$booking_id'
");

if(!$update) response(false,"Failed to cancel booking");

/* FETCH UPDATED BOOKING WITH ALL DETAILS */
$q2 = mysqli_query($conn,"
SELECT 
b.id as booking_id, 
b.customer_id, b.artist_id, b.booking_date, b.event_address, b.status, b.cancelled_by, b.cancel_reason, b.payment_status, b.payment_id, b.created_at,
c.name as customer_name, c.email as customer_email, c.phone as customer_phone,
a.name as artist_name, a.email as artist_email
FROM g_bookings b
JOIN g_users c ON b.customer_id=c.id
JOIN g_users a ON b.artist_id=a.id
WHERE b.id='$booking_id'
");
$updated = mysqli_fetch_assoc($q2);

/* REFUND LOGIC */
$refund_message = "";
if($updated['payment_status']=='paid'){
    $booking_date = new DateTime($updated['booking_date']);
    $today = new DateTime();
    $diff_days = $today->diff($booking_date)->days;

    if($diff_days <= 10){ 
        $refund_message = "Payment will be refunded within 10 business days.";
    } else {
        $refund_message = "Payment already passed 10-day refund window.";
    }
}

/* NOTIFY ARTIST */
$to = $updated['artist_email'];
$subject = "Booking Cancelled by Customer";
$message = "Hello ".$updated['artist_name'].",\nBooking on ".$updated['booking_date']." cancelled by ".$updated['customer_name'].".\nReason: ".$cancel_reason."\n".$refund_message;
@mail($to,$subject,$message,"From: no-reply@yourdomain.com");

/* RESPONSE */
$response_msg = "Booking cancelled successfully by customer";
if($refund_message != "") $response_msg .= " - ".$refund_message;

/* RETURN FULL BOOKING DATA INCLUDING booking_id */
response(true,$response_msg,$updated);
 