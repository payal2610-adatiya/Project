<?php

    define('HOST', 'localhost');
    define('USER', 'root');
    define('PASSWORD', '');
    define('DB_NAME','artist_hub');

    $con =mysqli_connect(HOST,USER,PASSWORD,DB_NAME) or die('Unable to Connect');

   
?>