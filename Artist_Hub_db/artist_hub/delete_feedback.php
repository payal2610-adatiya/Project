<?php
include "connect.php";

/* INPUT */
$feedback_id = intval($_POST['feedback_id'] ?? 0);
if($feedback_id <= 0) response(false,"Feedback ID is required");

/* Check feedback exists */
$q = mysqli_query($conn,"SELECT * FROM g_feedback WHERE id='$feedback_id'");
if(mysqli_num_rows($q) == 0) response(false,"Feedback not found");

/* Delete feedback */
$delete = mysqli_query($conn,"DELETE FROM g_feedback WHERE id='$feedback_id'");
if(!$delete) response(false,"Failed to delete feedback");

response(true,"Feedback deleted successfully");
