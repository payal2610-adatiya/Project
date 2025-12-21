<?php
include "connect.php";

/* INPUTS */
$user_id = intval($_POST['user_id'] ?? 0);
$message = trim($_POST['message'] ?? '');

/* VALIDATION */
if($user_id <= 0) response(false,"User ID is required");
if($message == '') response(false,"Message cannot be empty");

/* Check user exists */
$q = mysqli_query($conn,"SELECT id FROM g_users WHERE id='$user_id' AND is_active=1");
if(mysqli_num_rows($q) == 0) response(false,"User not found");

/* Insert feedback */
$insert = mysqli_query($conn,"
INSERT INTO g_feedback (user_id, message)
VALUES ('$user_id','$message')
");
if(!$insert) response(false,"Failed to add feedback");

/* Fetch inserted feedback */
$feedback_id = mysqli_insert_id($conn);
$q2 = mysqli_query($conn,"SELECT * FROM g_feedback WHERE id='$feedback_id'");
$feedback = mysqli_fetch_assoc($q2);

response(true,"Feedback added successfully",$feedback);
