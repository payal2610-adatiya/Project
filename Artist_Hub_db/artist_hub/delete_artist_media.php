<?php
include "connect.php";

$media_id  = intval($_POST['media_id'] ?? 0);
$artist_id = intval($_POST['artist_id'] ?? 0);

if($media_id <= 0) response(false,"Media ID required");
if($artist_id <= 0) response(false,"Artist ID required");

/* Ownership check */
$q = mysqli_query($conn,"
SELECT id FROM g_artist_media 
WHERE id='$media_id' AND artist_id='$artist_id'
");
if(mysqli_num_rows($q)==0) response(false,"Media not found or unauthorized");

/* Delete related data */
mysqli_query($conn,"DELETE FROM g_likes WHERE artist_media_id='$media_id'");
mysqli_query($conn,"DELETE FROM g_comments WHERE artist_media_id='$media_id'");
mysqli_query($conn,"DELETE FROM g_shares WHERE artist_media_id='$media_id'");

/* Delete media */
$del = mysqli_query($conn,"
DELETE FROM g_artist_media WHERE id='$media_id'
");
if(!$del) response(false,"Failed to delete media");

response(true,"Media deleted successfully");
