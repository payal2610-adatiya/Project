<?php
include "connect.php";

$artist_id = intval($_GET['artist_id'] ?? 0);
$media_id  = intval($_GET['media_id'] ?? 0);

$sql = "
SELECT am.*,
(SELECT COUNT(*) FROM g_likes WHERE artist_media_id=am.id) AS likes_count,
(SELECT COUNT(*) FROM g_comments WHERE artist_media_id=am.id) AS comments_count,
(SELECT COUNT(*) FROM g_shares WHERE artist_media_id=am.id) AS shares_count
FROM g_artist_media am
WHERE 1=1
";

if($artist_id > 0){
    $sql .= " AND am.artist_id='$artist_id'";
}
if($media_id > 0){
    $sql .= " AND am.id='$media_id'";
}

$sql .= " ORDER BY am.id DESC";

$q = mysqli_query($conn,$sql);
if(!$q) response(false,"Failed to fetch media");

$data = [];
while($row = mysqli_fetch_assoc($q)){
    $data[] = $row;
}

response(true,"Media fetched successfully",$data);