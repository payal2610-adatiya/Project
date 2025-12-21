<?php
include "connect.php";

/* INPUT */
$review_id = intval($_POST['review_id'] ?? 0);
if($review_id <= 0) response(false,"Review ID is required");

/* Check review exists */
$q = mysqli_query($conn,"SELECT * FROM g_reviews WHERE id='$review_id'");
if(mysqli_num_rows($q) == 0) response(false,"Review not found");

/* Delete review */
$delete = mysqli_query($conn,"DELETE FROM g_reviews WHERE id='$review_id'");
if(!$delete) response(false,"Failed to delete review");

response(true,"Review deleted successfully");
