<?php
include "connect.php";   // response() already available

$name     = trim($_POST['name'] ?? '');
$email    = trim($_POST['email'] ?? '');
$password = trim($_POST['password'] ?? '');
$phone    = trim($_POST['phone'] ?? '');
$address  = trim($_POST['address'] ?? '');
$role     = trim($_POST['role'] ?? '');

/* validations */
if($name == '')      response(false,"Name is required");
if($email == '')     response(false,"Email is required");

if(!preg_match('/^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.(com|in|net|org)$/',$email)){
    response(false,"Please enter a valid email address");
}

if($password == '')  response(false,"Password is required");
if(strlen($password) < 6) response(false,"Password must be at least 6 characters");

if($phone == '')     response(false,"Phone number is required");
if(!preg_match('/^[0-9]{10}$/',$phone))
    response(false,"Phone number must be 10 digits");

if($address == '')   response(false,"Address is required");

if($role == '')      response(false,"Role is required");
if($role != 'artist' && $role != 'customer')
    response(false,"Invalid role selected");

/* email unique */
$check = mysqli_query($conn,"SELECT id FROM g_users WHERE email='$email'");
if(mysqli_num_rows($check) > 0){
    response(false,"Email already exists");
}

/* role based approval */
$is_approved = ($role == 'customer') ? 1 : 0;

/* password hash */
$hashPassword = password_hash($password, PASSWORD_DEFAULT);

/* insert */
$insert = mysqli_query($conn,"
INSERT INTO g_users
(name,email,password,phone,address,role,is_approved)
VALUES
('$name','$email','$hashPassword','$phone','$address','$role','$is_approved')
");

if(!$insert){
    response(false,"Registration failed");
}

/* fetch inserted user */
$user_id = mysqli_insert_id($conn);

$user_q = mysqli_query($conn,"
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
WHERE id='$user_id'
");

$user = mysqli_fetch_assoc($user_q);

$responseMessage = ($role == 'artist')
    ? "Registration successful. Waiting for admin approval"
    : "Registration successful";

response(true,$responseMessage,$user);
    