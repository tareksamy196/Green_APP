<?php
// Database connection parameters
define('DB_SERVER', 'localhost');  // Replace with your MySQL server address
define('DB_USERNAME', 'root'); // Replace with your MySQL username
define('DB_PASSWORD', 'root@2024'); // Replace with your MySQL password
define('DB_DATABASE', 'cantu'); // Replace with your MySQL database name
function db_connect() {
   $conn = new mysqli(DB_SERVER, DB_USERNAME, DB_PASSWORD, DB_DATABASE);
   if ($conn->connect_error) {
       die("Connection failed: " . $conn->connect_error);
   }
   return $conn;
}