<?php
include "connect.php";

/* INPUTS */
$customer_id   = intval($_POST['customer_id'] ?? 0);
$artist_id     = intval($_POST['artist_id'] ?? 0);
$booking_date  = trim($_POST['booking_date'] ?? '');
$event_address = trim($_POST['event_address'] ?? '');
$payment_type  = trim($_POST['payment_type'] ?? ''); // required
$payment_id    = trim($_POST['payment_id'] ?? '');   // required if online

/* VALIDATION */

/* Customer & Artist IDs */
if($customer_id <= 0) response(false,"Customer ID is required");
if($artist_id <= 0) response(false,"Artist ID is required");

/* Booking date */
if($booking_date == '') response(false,"Booking date is required");
if(!preg_match('/^\d{4}-\d{2}-\d{2}$/', $booking_date)) response(false,"Booking date must be in YYYY-MM-DD format");

/* Event address */
if($event_address == '') response(false,"Event address is required");

/* Payment type */
if($payment_type == '') response(false,"Payment type is required");
if($payment_type != 'online' && $payment_type != 'cash') response(false,"Payment type must be either 'online' or 'cash'");

/* Payment ID validation */
if($payment_type == 'online' && $payment_id == '') response(false,"Payment ID is required for online payment");
if($payment_type == 'cash' && $payment_id != '') response(false,"Payment ID should not be provided for cash payment");

/* CHECK CUSTOMER EXISTS */
$cust_q = mysqli_query($conn,"SELECT id,name,email FROM g_users WHERE id='$customer_id' AND role='customer' AND is_active=1");
if(mysqli_num_rows($cust_q) == 0) response(false,"Customer not found");

/* CHECK ARTIST EXISTS */
$artist_q = mysqli_query($conn,"SELECT id,name,email FROM g_users WHERE id='$artist_id' AND role='artist' AND is_active=1");
if(mysqli_num_rows($artist_q) == 0) response(false,"Artist not found");

/* SET PAYMENT STATUS */
$payment_status = ($payment_type == 'online') ? 'paid' : 'pending';

/* INSERT BOOKING */
$insert = mysqli_query($conn,"
INSERT INTO g_bookings 
(customer_id, artist_id, booking_date, event_address, status, payment_status, payment_id)
VALUES 
('$customer_id','$artist_id','$booking_date','$event_address','booked','$payment_status','$payment_id')
");

if(!$insert) response(false,"Failed to add booking");

/* FETCH BOOKING DETAILS */
$booking_id = mysqli_insert_id($conn);
$q2 = mysqli_query($conn,"
SELECT b.*, 
c.name as customer_name, c.email as customer_email, c.phone as customer_phone,
a.name as artist_name, a.email as artist_email
FROM g_bookings b
JOIN g_users c ON b.customer_id=c.id
JOIN g_users a ON b.artist_id=a.id
WHERE b.id='$booking_id'
");
$booking = mysqli_fetch_assoc($q2);

/* NOTIFY ARTIST IF PAYMENT DONE ONLINE */
if($payment_status=='paid'){
    $to = $booking['artist_email'];
    $subject = "New Booking Received";
    $message = "Hello ".$booking['artist_name'].",\n\nYou have a new booking from ".$booking['customer_name']." on ".$booking_date.".\nEvent address: ".$event_address."\nPayment received online.";
    $headers = "From: no-reply@yourdomain.com";
    @mail($to,$subject,$message,$headers);
}

/* RESPONSE MESSAGE */
$response_msg = ($payment_status=='paid') 
    ? "Booking added successfully and payment received online" 
    : "Booking added successfully. Payment pending (cash)";

/* FINAL RESPONSE */
response(true,$response_msg,$booking);
