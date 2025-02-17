<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Headers: Content-Type");

include '../api/conn.php';

// Get the data from POST request
$uniname = $_POST['university_name'];
$uniemail = $_POST['uni_email'];
$unilocation = $_POST['uni_location'];
$uniusername = $_POST['uni_username'];
$unipassword = $_POST['uni_password'];

$clgname = $_POST['clg_name'];
$clgemail = $_POST['clg_email'];
$clglocation = $_POST['clg_location'];
$clgusername = $_POST['clg_username'];
$clgpassword = $_POST['clg_password'];

// Get the user type from the request (university or college)
$user_type = $_POST['user_type']; // "university" or "college"

// Conditional SQL queries based on user type
if ($user_type == 'university') {
    $sqlquery = "INSERT INTO university SET university_name = '$uniname', email  = '$uniemail', location = '$unilocation', username = '$uniusername', password = '$unipassword'";
} else if ($user_type == 'college') {
    $sqlquery = "INSERT INTO college SET name = '$clgname', email  = '$clgemail', location = '$clglocation', username = '$clgusername', password = '$clgpassword'";
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