<?php
include "connect.php";

$artist_id  = intval($_POST['artist_id'] ?? 0);
$media_type = $_POST['media_type'] ?? '';
$caption    = trim($_POST['caption'] ?? '');

if ($artist_id <= 0) response(false,"Artist ID required");
if (!in_array($media_type,['image','video'])) response(false,"Invalid media type");

if (!isset($_FILES['media'])) {
    response(false,"Media file is required");
}

/* CHECK ARTIST */
$chk = mysqli_query($conn,"
SELECT id FROM g_users 
WHERE id='$artist_id' AND role='artist' AND is_active=1
");
if (mysqli_num_rows($chk) == 0) response(false,"Artist not found");

/* FILE VALIDATION */
$file = $_FILES['media'];
$ext  = strtolower(pathinfo($file['name'], PATHINFO_EXTENSION));

$image_ext = ['jpg','jpeg','png','webp'];
$video_ext = ['mp4','mov','avi','mkv'];

if ($media_type == 'image' && !in_array($ext,$image_ext)) {
    response(false,"Invalid image format");
}

if ($media_type == 'video' && !in_array($ext,$video_ext)) {
    response(false,"Invalid video format");
}

/* UPLOAD PATH */
$folder = ($media_type == 'image') ? "uploads/images/" : "uploads/videos/";
if (!is_dir($folder)) mkdir($folder,0777,true);

$filename = time()."_".rand(1000,9999).".".$ext;
$filepath = $folder.$filename;

/* MOVE FILE */
if (!move_uploaded_file($file['tmp_name'],$filepath)) {
    response(false,"Failed to upload file");
}

/* SAVE TO DB */
$q = mysqli_query($conn,"
INSERT INTO g_artist_media (artist_id, media_type, media_url, caption)
VALUES ('$artist_id','$media_type','$filepath','$caption')
");

if (!$q) response(false,"Failed to save media");

response(true,"Media uploaded successfully",[
    "media_id" => mysqli_insert_id($conn),
    "media_url" => $filepath
]);