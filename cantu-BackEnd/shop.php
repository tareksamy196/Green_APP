<?php
// Database connection parameters
define('DB_SERVER', 'localhost');  // Replace with your MySQL server address
define('DB_USERNAME', 'root'); // Replace with your MySQL username
define('DB_PASSWORD', ''); // Replace with your MySQL password
define('DB_DATABASE', 'shop'); // Replace with your MySQL database name

// Function to establish a database connection
function db_connect() {
    $conn = new mysqli(DB_SERVER, DB_USERNAME, DB_PASSWORD, DB_DATABASE);
    if ($conn->connect_error) {
        die("Connection failed: " . $conn->connect_error);
    }
    return $conn;
}

// Function to sanitize user input
function sanitize_input($input) {
    $input = trim($input);
    $input = stripslashes($input);
    $input = htmlspecialchars($input);
    return $input;
}

// Function to authenticate user
function authenticate_user($conn, $username, $password) {
    $username = sanitize_input($username);
    $password = sanitize_input($password);

    $stmt = $conn->prepare("SELECT * FROM users WHERE username = ? AND password = ?");
    $stmt->bind_param("ss", $username, $password);
    $stmt->execute();
    $result = $stmt->get_result();

    if ($result->num_rows > 0) {
        return true; // User exists
    } else {
        return false; // User does not exist or invalid credentials
    }
}

// Check if form is submitted
if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $conn = db_connect();
    $username = $_POST["username"];
    $password = $_POST["password"];

    if (authenticate_user($conn, $username, $password)) {
        // User authenticated successfully, redirect to dashboard or home page
        header("Location: dashboard.php");
        exit();
    } else {
        $error_message = "Invalid username or password.";
    }

    $conn->close();
}

?>