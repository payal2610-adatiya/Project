<?php
include "connect.php";

/* optional: fetch by profile id or user_id */
$profile_id = intval($_GET['id'] ?? 0);
$user_id    = intval($_GET['user_id'] ?? 0);

/* base query with only active users */
$where = "u.is_active=1"; // only active artists

if($profile_id > 0){
    $where .= " AND p.id='$profile_id'";
}elseif($user_id > 0){
    $where .= " AND p.user_id='$user_id'";
}

$q = mysqli_query($conn,"
SELECT p.*, u.name as artist_name, u.email as artist_email
FROM g_artist_profile p
JOIN g_users u ON p.user_id = u.id
WHERE $where
");

$profiles = [];
while($row = mysqli_fetch_assoc($q)){
    $profiles[] = $row;
}

if(count($profiles) == 0){
    response(true,"No artist profiles found",[]);
}else{
    response(true,"Artist profiles fetched successfully",$profiles);
}
