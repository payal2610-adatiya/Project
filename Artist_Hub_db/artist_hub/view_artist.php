<?php
include "connect.php";

/* FETCH ARTISTS ONLY */
$q = mysqli_query($conn,"
SELECT 
id,
name,
email,
phone,
address,
role,
is_approved,
is_active,
created_at
FROM g_users
WHERE role='artist' AND is_active=1
ORDER BY created_at DESC
");

$artists = [];
while($row = mysqli_fetch_assoc($q)){
    $artists[] = $row;
}

if(count($artists) == 0){
    response(true,"No artists found",[]);
}else{
    response(true,"Artists fetched successfully",$artists);
}
