<?php
include "connect.php";

$media_id = intval($_GET['media_id'] ?? 0);
if($media_id<=0) response(false,"Media ID required");

$q = mysqli_query($conn,"
SELECT c.*,u.name,u.email
FROM g_comments c
JOIN g_users u ON c.user_id=u.id
WHERE c.artist_media_id='$media_id'
ORDER BY c.id DESC
");

$data=[];
while($row=mysqli_fetch_assoc($q)){
    $data[]=$row;
}

response(true,"Comments fetched",[
    "total_comments"=>count($data),
    "comments"=>$data
]);
