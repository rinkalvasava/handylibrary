<?php

// Database credentials
$host = 'localhost';
$username = 'root';
$password = ''; // Replace with your database password
$database = 'HL';

// Create connection
$conn = new mysqli($host, $username, $password, $database);

// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
} else {
    echo "Connected successfully";
}

?>
