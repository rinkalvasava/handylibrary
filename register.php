<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Headers: Content-Type");

include '../api/conn.php';

// Get the data from POST request
$university_name = $_POST['university_name'];
$email = $_POST['email'];
$location = $_POST['location'];
$username = $_POST['username'];
$password = $_POST['password'];

$name = $_POST['name'];
$email = $_POST['email'];
$location = $_POST['location'];
$username = $_POST['username'];
$password = $_POST['password'];

// Get the user type from the request (university or college)
$user_type = $_POST['user_type']; // "university" or "college"

// Conditional SQL queries based on user type
if ($user_type == 'university') {
    $sqlquery = "INSERT INTO university SET university_name = '$university_name', email  = '$email', location = '$location', username = '$username', password = '$password'";
} else if ($user_type == 'college') {
    $sqlquery = "INSERT INTO college SET name = '$name', email  = '$email', location = '$location', username = '$username', password = '$password'";
} else {
    echo json_encode(array("success" => false, "message" => "Invalid user type"));
    exit;
}

// Execute the query
$result = $connectNow->query($sqlquery);

// Respond based on the result
if ($result) {
    echo json_encode(array("success" => true));
} else {
    echo json_encode(array("success" => false));
}
?>
