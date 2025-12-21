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

if($category == '') response(false,"Category is required");
if($experience == '') response(false,"Experience is required");
if($price == '') response(false,"Price is required");
if(!is_numeric($price) || $price < 0) response(false,"Price must be a positive number");
if($description == '') response(false,"Description is required");

/* check profile exists */
$check = mysqli_query($conn,"
SELECT id FROM g_artist_profile WHERE user_id='$user_id'
");

if(mysqli_num_rows($check) == 0){
    response(false,"Artist profile not found");
}

/* update */
$update = mysqli_query($conn,"
UPDATE g_artist_profile SET
category='$category',
experience='$experience',
price='$price',
description='$description'
WHERE user_id='$user_id'
");

if(!$update) response(false,"Failed to update artist profile");

/* fetch updated profile */
$q2 = mysqli_query($conn,"
SELECT p.*, u.name AS artist_name, u.email AS artist_email
FROM g_artist_profile p
JOIN g_users u ON p.user_id = u.id
WHERE p.user_id='$user_id'
");

$profile = mysqli_fetch_assoc($q2);

response(true,"Artist profile updated successfully",$profile);
