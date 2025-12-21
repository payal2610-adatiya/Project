<?php
include "connect.php";

$comment_id = intval($_POST['comment_id'] ?? 0);
$user_id    = intval($_POST['user_id'] ?? 0);

if($comment_id<=0) response(false,"Comment ID required");
if($user_id<=0) response(false,"User ID required");

/* ownership */
$q = mysqli_query($conn,"
SELECT id FROM g_comments 
WHERE id='$comment_id' AND user_id='$user_id'
");
if(mysqli_num_rows($q)==0) response(false,"Unauthorized");

mysqli_query($conn,"DELETE FROM g_comments WHERE id='$comment_id'");

response(true,"Comment deleted");
