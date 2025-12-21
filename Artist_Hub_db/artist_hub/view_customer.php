<?php
include "connect.php";

/* FETCH CUSTOMERS ONLY */
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
WHERE role='customer' AND is_active=1
ORDER BY created_at DESC
");

$customers = [];
while($row = mysqli_fetch_assoc($q)){
    $customers[] = $row;
}

if(count($customers) == 0){
    response(true,"No customers found",[]);
}else{
    response(true,"Customers fetched successfully",$customers);
}
