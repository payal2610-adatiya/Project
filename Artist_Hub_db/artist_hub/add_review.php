<?php
include "connect.php";

/* INPUTS */
$booking_id  = intval($_POST['booking_id'] ?? 0);
$artist_id   = intval($_POST['artist_id'] ?? 0);
$customer_id = intval($_POST['customer_id'] ?? 0);
$rating      = intval($_POST['rating'] ?? 0);
$comment     = trim($_POST['comment'] ?? '');

/* VALIDATION */
if($booking_id <= 0) response(false,"Booking ID is required");
if($artist_id <= 0) response(false,"Artist ID is required");
if($customer_id <= 0) response(false,"Customer ID is required");
if($rating < 1 || $rating > 5) response(false,"Rating must be between 1 and 5");
if($comment == '') response(false,"Comment cannot be empty");

/* Check booking exists */
$q_booking = mysqli_query($conn,"SELECT * FROM g_bookings WHERE id='$booking_id' AND customer_id='$customer_id' AND artist_id='$artist_id'");
if(mysqli_num_rows($q_booking)==0) response(false,"Booking not found");

/* Insert review */
$insert = mysqli_query($conn,"
INSERT INTO g_reviews (booking_id, artist_id, customer_id, rating, comment)
VALUES ('$booking_id','$artist_id','$customer_id','$rating','$comment')
");

if(!$insert) response(false,"Failed to add review");

/* Fetch inserted review */
$review_id = mysqli_insert_id($conn);
$q2 = mysqli_query($conn,"SELECT * FROM g_reviews WHERE id='$review_id'");
$review = mysqli_fetch_assoc($q2);

response(true,"Review added successfully",$review);
