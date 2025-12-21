<?php
include "connect.php";

/* INPUTS */
$artist_id = intval($_POST['artist_id'] ?? 0);

if($artist_id <= 0) response(false,"Artist ID is required");

/* CHECK ARTIST EXISTS */
$q = mysqli_query($conn,"
SELECT id,name,email,phone,address,role,is_approved,is_active,created_at
FROM g_users
WHERE id='$artist_id' AND role='artist'
LIMIT 1
");

if(mysqli_num_rows($q) == 0){
    response(false,"Artist not found");
}

$artist = mysqli_fetch_assoc($q);

/* CHECK ALREADY APPROVED */
if($artist['is_approved'] == 1){
    response(false,"Artist already approved");
}

/* APPROVE ARTIST (ADMIN ID = 1 fixed) */
$update = mysqli_query($conn,"
UPDATE g_users
SET is_approved = 1
WHERE id='$artist_id'
");

if(!$update){
    response(false,"Failed to approve artist");
}

/* FETCH UPDATED ARTIST DATA */
$q2 = mysqli_query($conn,"
SELECT id,name,email,phone,address,role,is_approved,is_active,created_at
FROM g_users
WHERE id='$artist_id'
");

$updated_artist = mysqli_fetch_assoc($q2);

response(true,"Artist approved successfully",$updated_artist);
