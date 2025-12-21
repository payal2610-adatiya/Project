<?php
include "connect.php";

$user_id  = intval($_POST['user_id'] ?? 0);
$media_id = intval($_POST['media_id'] ?? 0);
$comment  = trim($_POST['comment'] ?? '');

if($user_id<=0) response(false,"User ID required");
if($media_id<=0) response(false,"Media ID required");
if($comment=='') response(false,"Comment required");

/* insert */
$q = mysqli_query($conn,"
INSERT INTO g_comments (user_id, artist_media_id, comment)
VALUES ('$user_id','$media_id','$comment')
");
if(!$q) response(false,"Failed to add comment");

response(true,"Comment added",[
    "comment_id"=>mysqli_insert_id($conn)
]);
