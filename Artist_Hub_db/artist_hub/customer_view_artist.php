<?php
include "connect.php";

/*
Customer ne badha artist batavva mate API
Only:
- role = artist
- is_active = 1
- is_approved = 1
*/

$q = mysqli_query($conn,"
SELECT 
u.id,
u.name,
u.email,
u.phone,
u.address,
u.created_at
FROM g_users u
WHERE u.role='artist'
AND u.is_active=1
AND u.is_approved=1
ORDER BY u.id DESC
");

if(!$q){
    response(false,"Failed to fetch artists");
}

$artists = [];
while($row = mysqli_fetch_assoc($q)){
    $artists[] = $row;
}

if(count($artists) == 0){
    response(true,"No artists found",[]);
}

response(true,"Artists fetched successfully",$artists);
