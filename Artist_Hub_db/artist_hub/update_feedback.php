<?php
include "connect.php";

/* INPUTS */
$feedback_id = intval($_POST['feedback_id'] ?? 0);
$message     = trim($_POST['message'] ?? '');

/* VALIDATION */
if($feedback_id <= 0) response(false,"Feedback ID is required");
if($message == '') response(false,"Message cannot be empty");

/* Check feedback exists */
$q = mysqli_query($conn,"SELECT * FROM g_feedback WHERE id='$feedback_id'");
if(mysqli_num_rows($q) == 0) response(false,"Feedback not found");

/* Update feedback */
$update = mysqli_query($conn,"
UPDATE g_feedback SET message='$message' WHERE id='$feedback_id'
");
if(!$update) response(false,"Failed to update feedback");

/* Fetch updated feedback */
$q2 = mysqli_query($conn,"SELECT * FROM g_feedback WHERE id='$feedback_id'");
$feedback = mysqli_fetch_assoc($q2);

response(true,"Feedback updated successfully",$feedback);
