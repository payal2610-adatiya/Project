<?php
include "connect.php";

/*
Optional:
?id=1  -> single user
No id  -> all users
*/

$id = intval($_GET['id'] ?? 0);

if($id > 0){

    $q = mysqli_query($conn,"
    SELECT
    id,name,email,phone,address,role,is_approved,is_active,created_at
    FROM g_users
    WHERE id='$id' AND is_active=1
    ");

    if(mysqli_num_rows($q) == 0){
        response(false,"User not found");
    }

    $data = mysqli_fetch_assoc($q);
    response(true,"User details",$data);

}else{

    $q = mysqli_query($conn,"
    SELECT
    id,name,email,phone,address,role,is_approved,is_active,created_at
    FROM g_users
    WHERE is_active=1
    ORDER BY id DESC
    ");

    $data = [];
    while($row = mysqli_fetch_assoc($q)){
        $data[] = $row;
    }

    response(true,"User list",$data);
}
