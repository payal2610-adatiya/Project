<?php
include "connect.php";

/* INPUTS */
$review_id   = intval($_POST['review_id'] ?? 0);
$rating      = intval($_POST['rating'] ?? 0);
$comment     = trim($_POST['comment'] ?? '');

/* VALIDATION */
if($review_id <= 0) response(false,"Review ID is required");
if($rating < 1 || $rating > 5) response(false,"Rating must be between 1 and 5");
if($comment == '') response(false,"Comment cannot be empty");

/* Check review exists */
$q = mysqli_query($conn,"SELECT * FROM g_reviews WHERE id='$review_id'");
if(mysqli_num_rows($q) == 0) response(false,"Review not found");

/* Update review */
$update = mysqli_query($conn,"
UPDATE g_reviews SET rating='$rating', comment='$comment' WHERE id='$review_id'
");
if(!$update) response(false,"Failed to update review");

/* Fetch updated review */
$q2 = mysqli_query($conn,"SELECT * FROM g_reviews WHERE id='$review_id'");
$review = mysqli_fetch_assoc($q2);

response(true,"Review updated successfully",$review);
