<?php
include "connect.php";

/* INPUT */
$artist_id = intval($_GET['artist_id'] ?? 0);

if($artist_id <= 0) response(false,"Artist ID is required");

/* Verify artist */
$chk = mysqli_query($conn,"
SELECT id FROM g_users 
WHERE id='$artist_id' AND role='artist' AND is_active=1
");
if(mysqli_num_rows($chk)==0) response(false,"Artist not found");

/* Fetch artist posts with counts */
$q = mysqli_query($conn,"
SELECT 
    m.id AS media_id,
    m.media_type,
    m.media_url,
    m.caption,
    m.created_at,

    (SELECT COUNT(*) FROM g_likes WHERE artist_media_id = m.id) AS total_likes,
    (SELECT COUNT(*) FROM g_comments WHERE artist_media_id = m.id) AS total_comments,
    (SELECT COUNT(*) FROM g_shares WHERE artist_media_id = m.id) AS total_shares

FROM g_artist_media m
WHERE m.artist_id='$artist_id'
ORDER BY m.id DESC
");

$posts = [];
while($row = mysqli_fetch_assoc($q)){
    $posts[] = $row;
}

if(count($posts)==0){
    response(true,"No posts found",[]);
}

response(true,"Artist posts fetched successfully",$posts);
