<?php
include "connect.php";

/* fetch only active pending artists */
$q = mysqli_query($conn,"
SELECT id,name,email,phone,address,role,is_approved,is_active,created_at
FROM g_users
WHERE role='artist' AND is_approved=0 AND is_active=1
ORDER BY created_at DESC
");

$pending_artists = [];
while($row = mysqli_fetch_assoc($q)){
    $pending_artists[] = $row;
}

if(count($pending_artists) == 0){
    response(true,"No pending artists",[]);
}else{
    response(true,"Pending artists fetched successfully",$pending_artists);
}
