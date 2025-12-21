<?php
include "connect.php";

$comment_id = intval($_POST['comment_id'] ?? 0);
$user_id    = intval($_POST['user_id'] ?? 0);
$comment    = trim($_POST['comment'] ?? '');

if($comment_id<=0) response(false,"Comment ID required");
if($user_id<=0) response(false,"User ID required");
if($comment=='') response(false,"Comment required");

/* ownership check */
$q = mysqli_query($conn,"
SELECT id FROM g_comments 
WHERE id='$comment_id' AND user_id='$user_id'
");
if(mysqli_num_rows($q)==0) response(false,"Unauthorized");

mysqli_query($conn,"
UPDATE g_comments SET comment='$comment'
WHERE id='$comment_id'
");

response(true,"Comment updated");
