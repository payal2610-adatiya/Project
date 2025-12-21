<?php
include "connect.php";

$media_id = intval($_GET['media_id'] ?? 0);
if($media_id<=0) response(false,"Media ID required");

$q = mysqli_query($conn,"
SELECT u.id,u.name,u.email
FROM g_likes l
JOIN g_users u ON l.user_id=u.id
WHERE l.artist_media_id='$media_id'
ORDER BY l.id DESC
");

$data=[];
while($row=mysqli_fetch_assoc($q)){
    $data[]=$row;
}

response(true,"Likes fetched",[
    "total_likes"=>count($data),
    "likes"=>$data
]);
