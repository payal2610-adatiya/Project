
<?php
include "connect.php";

/* INPUTS */
$artist_id = intval($_GET['artist_id'] ?? 0);

if ($artist_id <= 0) response(false,"Artist ID required");

/* CHECK ARTIST */
$chk = mysqli_query($conn,"
SELECT id FROM g_users 
WHERE id='$artist_id' AND role='artist' AND is_active=1
");
if (mysqli_num_rows($chk)==0) response(false,"Artist not found");

/* FETCH MEDIA */
$q = mysqli_query($conn,"
SELECT 
m.*,
(SELECT COUNT(*) FROM g_likes WHERE artist_media_id=m.id) AS like_count,
(SELECT COUNT(*) FROM g_comments WHERE artist_media_id=m.id) AS comment_count,
(SELECT COUNT(*) FROM g_shares WHERE artist_media_id=m.id) AS share_count
FROM g_artist_media m
WHERE m.artist_id='$artist_id'
ORDER BY m.created_at DESC
");

$data = [];
while($row = mysqli_fetch_assoc($q)){
    $data[] = $row;
}

response(true,"Artist media fetched",$data);
