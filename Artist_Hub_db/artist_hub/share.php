<?php
include "connect.php";

$user_id  = intval($_POST['user_id'] ?? 0);
$media_id = intval($_POST['media_id'] ?? 0);

if($user_id<=0) response(false,"User ID required");
if($media_id<=0) response(false,"Media ID required");

mysqli_query($conn,"
INSERT INTO g_shares (user_id, artist_media_id)
VALUES ('$user_id','$media_id')
");

$c = mysqli_fetch_assoc(mysqli_query($conn,"
SELECT COUNT(*) total FROM g_shares WHERE artist_media_id='$media_id'
"));

response(true,"Post shared",[
    "total_shares"=>$c['total']
]);
