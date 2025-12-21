<?php
include "connect.php";

$user_id  = intval($_POST['user_id'] ?? 0);
$media_id = intval($_POST['media_id'] ?? 0);

if($user_id<=0) response(false,"User ID required");
if($media_id<=0) response(false,"Media ID required");

/* check media */
$m = mysqli_query($conn,"SELECT id FROM g_artist_media WHERE id='$media_id'");
if(mysqli_num_rows($m)==0) response(false,"Media not found");

/* check already liked */
$q = mysqli_query($conn,"
SELECT id FROM g_likes 
WHERE user_id='$user_id' AND artist_media_id='$media_id'
");

if(mysqli_num_rows($q)>0){
    mysqli_query($conn,"DELETE FROM g_likes WHERE user_id='$user_id' AND artist_media_id='$media_id'");
    $status = "unliked";
}else{
    mysqli_query($conn,"INSERT INTO g_likes (user_id, artist_media_id) VALUES ('$user_id','$media_id')");
    $status = "liked";
}

/* count */
$c = mysqli_fetch_assoc(mysqli_query($conn,"
SELECT COUNT(*) total FROM g_likes WHERE artist_media_id='$media_id'
"));

response(true,"Post ".$status,[
    "like_status"=>$status,
    "total_likes"=>$c['total']
]);
