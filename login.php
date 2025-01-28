<?php
header('Content-Type: application/json');

$servername = "localhost"; // Replace with your server name
$username = "root";        // Replace with your database username
$password = "1234";            // Replace with your database password
$dbname = "handy_library"; // Replace with your database name

// Create connection
$conn = new mysqli($servername, $username, $password, $dbname);

// Check connection
if ($conn->connect_error) {
    die(json_encode(['status' => 'error', 'message' => 'Database connection failed']));
}

// Get data from POST request
$username = $_POST['username'];
$password = $_POST['password'];
$role = $_POST['role'];

// Validate inputs
if (empty($email) || empty($password) || empty($role)) {
    echo json_encode(['status' => 'error', 'message' => 'All fields are required']);
    exit();
}

// Determine the table based on the role
$table = '';
if ($role === 'College') {
    $table = 'college';
} elseif ($role === 'Student') {
    $table = 'student';
} elseif ($role === 'University') {
    $table = 'university';
}

// Check if the user exists
$sql = "SELECT * FROM $table WHERE email = ?";
$stmt = $conn->prepare($sql);
$stmt->bind_param("s", $email);
$stmt->execute();
$result = $stmt->get_result();

if ($result->num_rows > 0) {
    $user = $result->fetch_assoc();
    if (password_verify($password, $user['password'])) {
        echo json_encode(['status' => 'success', 'message' => 'Login successful', 'role' => $role]);
    } else {
        echo json_encode(['status' => 'error', 'message' => 'Incorrect password']);
    }
} else {
    echo json_encode(['status' => 'error', 'message' => 'User not found']);
}

$stmt->close();
$conn->close();
?>