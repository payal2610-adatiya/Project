<?php
include "connect.php";

/* INPUTS */
$user_id     = intval($_POST['user_id'] ?? 0);
$category    = trim($_POST['category'] ?? '');
$experience  = trim($_POST['experience'] ?? '');
$price       = trim($_POST['price'] ?? '');
$description = trim($_POST['description'] ?? '');

/* VALIDATION */
if($user_id <= 0) response(false,"User ID is required");

/* check user exists and role=artist */
$user_q = mysqli_query($conn,"SELECT id,name,email FROM g_users WHERE id='$user_id' AND role='artist'");
if(mysqli_num_rows($user_q) == 0) response(false,"Artist not found");
$artist = mysqli_fetch_assoc($user_q);  // fetch name & email

/* validate other fields */
if($category == '') response(false,"Category is required");
if($experience == '') response(false,"Experience is required");
if($price == '') response(false,"Price is required");
if(!is_numeric($price) || $price < 0) response(false,"Price must be a positive number");
if($description == '') response(false,"Description is required");

/* insert */
$insert = mysqli_query($conn,"
INSERT INTO g_artist_profile (user_id, category, experience, price, description)
VALUES ('$user_id','$category','$experience','$price','$description')
");

if(!$insert) response(false,"Failed to insert artist profile");

/* fetch inserted profile */
$profile_id = mysqli_insert_id($conn);
$q2 = mysqli_query($conn,"SELECT * FROM g_artist_profile WHERE id='$profile_id'");
$profile = mysqli_fetch_assoc($q2);

/* attach artist name & email to response */
$profile['artist_name'] = $artist['name'];
$profile['artist_email'] = $artist['email'];

response(true,"Artist profile inserted successfully",$profile);
