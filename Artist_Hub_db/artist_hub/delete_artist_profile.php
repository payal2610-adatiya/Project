<?php
include "connect.php";

$id = intval($_POST['id'] ?? 0);
if($id <= 0) response(false,"Profile ID is required");

/* check profile exists */
$q = mysqli_query($conn,"SELECT * FROM g_artist_profile WHERE id='$id'");
if(mysqli_num_rows($q) == 0) response(false,"Artist profile not found");

/* delete */
$delete = mysqli_query($conn,"DELETE FROM g_artist_profile WHERE id='$id'");
if(!$delete) response(false,"Failed to delete artist profile");

response(true,"Artist profile deleted successfully");
