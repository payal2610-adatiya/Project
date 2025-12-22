<?php
echo "<h2>Gaurang API</h2>";
echo "<ul>";

/* CONNECTION */
echo "<li><a href='gaurang/connect.php'>DB Connection</a></li>";

/* AUTH */
echo "<li><a href='gaurang/register.php'>Register</a></li>";
echo "<li><a href='gaurang/login.php'>Login</a></li>";
echo "<li><a href='gaurang/admin_login.php'>Admin Login</a></li>";

/* ARTIST */
echo "<li><a href='gaurang/add_artist_profile.php'>Add Artist Profile</a></li>";
echo "<li><a href='gaurang/update_artist_profile.php'>Update Artist Profile</a></li>";
echo "<li><a href='gaurang/delete_artist_profile.php'>Delete Artist Profile</a></li>";
echo "<li><a href='gaurang/view_artist_profile.php'>View Artist Profile</a></li>";
echo "<li><a href='gaurang/artist_details.php'>Artist Details</a></li>";
echo "<li><a href='gaurang/artist_pending_request.php'>Artist Pending Requests</a></li>";
echo "<li><a href='gaurang/artist_aproval.php'>Artist Approval</a></li>";

/* ARTIST MEDIA */
echo "<li><a href='gaurang/add_artist_media.php'>Add Artist Media</a></li>";
echo "<li><a href='gaurang/update_artist_media.php'>Update Artist Media</a></li>";
echo "<li><a href='gaurang/delete_artist_media.php'>Delete Artist Media</a></li>";
echo "<li><a href='gaurang/view_artist_media.php'>View Artist Media</a></li>";
echo "<li><a href='gaurang/view_artist_media_by_id.php'>View Artist Media By ID</a></li>";

/* BOOKINGS */
echo "<li><a href='gaurang/add_bookings.php'>Add Booking</a></li>";
echo "<li><a href='gaurang/update_bookings.php'>Update Booking</a></li>";
echo "<li><a href='gaurang/view_booking.php'>View Booking</a></li>";
echo "<li><a href='gaurang/view_boking_by_id.php'>View Booking By ID</a></li>";
echo "<li><a href='gaurang/view_booking_by_admin.php'>View Booking By Admin</a></li>";
echo "<li><a href='gaurang/customer_booking_cancel.php'>Customer Booking Cancel</a></li>";
echo "<li><a href='gaurang/artist_booking_cancel.php'>Artist Booking Cancel</a></li>";

/* PAYMENTS */
echo "<li><a href='gaurang/add_payments.php'>Add Payment</a></li>";
echo "<li><a href='gaurang/view_payments.php'>View Payments</a></li>";

/* COMMENTS */
echo "<li><a href='gaurang/add_comments.php'>Add Comment</a></li>";
echo "<li><a href='gaurang/update_comments.php'>Update Comment</a></li>";
echo "<li><a href='gaurang/delete_comments.php'>Delete Comment</a></li>";
echo "<li><a href='gaurang/view_comments.php'>View Comments</a></li>";

/* LIKES & SHARES */
echo "<li><a href='gaurang/like.php'>Like</a></li>";
echo "<li><a href='gaurang/share.php'>Share</a></li>";
echo "<li><a href='gaurang/view_like.php'>View Likes</a></li>";

/* REVIEWS */
echo "<li><a href='gaurang/add_review.php'>Add Review</a></li>";
echo "<li><a href='gaurang/update_review.php'>Update Review</a></li>";
echo "<li><a href='gaurang/delete_review.php'>Delete Review</a></li>";
echo "<li><a href='gaurang/view_review.php'>View Reviews</a></li>";

/* FEEDBACK */
echo "<li><a href='gaurang/add_feedback.php'>Add Feedback</a></li>";
echo "<li><a href='gaurang/update_feedback.php'>Update Feedback</a></li>";
echo "<li><a href='gaurang/delete_feedback.php'>Delete Feedback</a></li>";
echo "<li><a href='gaurang/view_feedback.php'>View Feedback</a></li>";
echo "<li><a href='gaurang/view_feedback_artist.php'>View Artist Feedback</a></li>";

/* USERS */
echo "<li><a href='gaurang/view_user.php'>View Users</a></li>";
echo "<li><a href='gaurang/view_customer.php'>View Customers</a></li>";
echo "<li><a href='gaurang/update_user.php'>Update User</a></li>";
echo "<li><a href='gaurang/delete_user.php'>Delete User</a></li>";

/* CUSTOMER */
echo "<li><a href='gaurang/customer_view_artist.php'>Customer View Artist</a></li>";

echo "</ul>";
?>
