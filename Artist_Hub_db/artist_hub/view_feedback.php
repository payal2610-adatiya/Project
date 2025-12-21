<?php
include "connect.php";

/* optional filter by user */
$user_id = intval($_GET['user_id'] ?? 0);

$where = "1";
if($user_id > 0) $where .= " AND f.user_id='$user_id'";

/* Fetch feedbacks with user info */
$q = mysqli_query($conn,"
SELECT f.*, u.name as user_name, u.email as user_email
FROM g_feedback f
JOIN g_users u ON f.user_id=u.id
WHERE $where
ORDER BY f.created_at DESC
");

$feedbacks = [];
while($row = mysqli_fetch_assoc($q)){
    $feedbacks[] = $row;
}

if(count($feedbacks) == 0){
    response(true,"No feedback found",[]);
}else{
    response(true,"Feedback fetched successfully",$feedbacks);
}
