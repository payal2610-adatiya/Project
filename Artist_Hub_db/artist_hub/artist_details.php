<?php
include "connect.php";

/* INPUT */
$artist_id = intval($_GET['artist_id'] ?? 0);

if($artist_id <= 0){
    response(false,"Artist ID is required");
}

/* CHECK ARTIST */
$artist_q = mysqli_query($conn,"
SELECT id, name, email, phone, address, created_at
FROM g_users
WHERE id='$artist_id'
AND role='artist'
AND is_active=1
AND is_approved=1
");

if(mysqli_num_rows($artist_q) == 0){
    response(false,"Artist not found or not approved");
}

$artist = mysqli_fetch_assoc($artist_q);

/* FETCH ARTIST PROFILE */
$profile_q = mysqli_query($conn,"
SELECT category, experience, price, description
FROM g_artist_profile
WHERE user_id='$artist_id'
");

$artist['profile'] = mysqli_fetch_assoc($profile_q) ?: null;

/* FETCH RATINGS */
$rating_q = mysqli_query($conn,"
SELECT 
COUNT(id) as total_reviews,
AVG(rating) as avg_rating
FROM g_reviews
WHERE artist_id='$artist_id'
");

$rating = mysqli_fetch_assoc($rating_q);
$artist['total_reviews'] = intval($rating['total_reviews']);
$artist['avg_rating'] = $rating['avg_rating'] ? round($rating['avg_rating'],1) : 0;

/* FETCH RECENT REVIEWS */
$review_q = mysqli_query($conn,"
SELECT 
r.id,
r.rating,
r.comment,
r.created_at,
u.name as customer_name
FROM g_reviews r
JOIN g_users u ON r.customer_id=u.id
WHERE r.artist_id='$artist_id'
ORDER BY r.id DESC
LIMIT 5
");

$reviews = [];
while($row = mysqli_fetch_assoc($review_q)){
    $reviews[] = $row;
}
$artist['recent_reviews'] = $reviews;

/* FETCH POSTS COUNT */
$post_q = mysqli_query($conn,"
SELECT COUNT(id) as total_posts
FROM g_artist_media
WHERE artist_id='$artist_id'
");

$post = mysqli_fetch_assoc($post_q);
$artist['total_posts'] = intval($post['total_posts']);

/* FINAL RESPONSE */
response(true,"Artist details fetched successfully",$artist);
