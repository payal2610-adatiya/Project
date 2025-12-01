<?php
header('Content-Type: application/json');
include 'connect.php';
$data = json_decode(file_get_contents("php://input"), true);

if(!$data || !isset($data['artist_id'])) {
    echo json_encode(["status"=>false,"message"=>"Missing artist_id"]);
    exit;
}

$artist_id = $data['artist_id'];
$name = $data['name'] ?? null;
$phone = $data['phone'] ?? null;
$address = $data['address'] ?? null;
$status = $data['status'] ?? null;
$profile_pic = $data['profile_pic'] ?? null;
$categories = $data['categories'] ?? null; // optional array

try {
    $con->beginTransaction();
    $stmt = $con->prepare("UPDATE g_users SET name = COALESCE(?, name), phone = COALESCE(?, phone), address = COALESCE(?, address), status = COALESCE(?, status), profile_pic = COALESCE(?, profile_pic) WHERE user_id = ? AND role = 'artist'");
    $stmt->execute([$name,$phone,$address,$status,$profile_pic,$artist_id]);

    if(is_array($categories)) {
        $del = $con->prepare("DELETE FROM g_artist_category WHERE artist_id = ?");
        $del->execute([$artist_id]);
        $ins = $con->prepare("INSERT INTO g_artist_category (artist_id, category_id) VALUES (?, ?)");
        foreach($categories as $cat_id) {
            $ins->execute([$artist_id, $cat_id]);
        }
    }

    $con->commit();
    echo json_encode(["status"=>true,"message"=>"Artist updated"]);
} catch(PDOException $e) {
    $con->rollBack();
    echo json_encode(["status"=>false,"message"=>$e->getMessage()]);
}
?>