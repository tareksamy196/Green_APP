<?php
require '../../accesstoken.php'; // Include the Composer autoloader
require '../../connect.php';
// Database connection parameters
// Replace with your MySQL database name


// Function to establish a database connection

// Function to sanitize user input
function sanitize_input($input) {
    $input = trim($input);
    $input = stripslashes($input);
    $input = htmlspecialchars($input);
    return $input;
}

// Function to authenticate user
function authenticate_user($conn, $email, $password) {
    $email = sanitize_input($email);
    $password = sanitize_input($password);
   
    $stmt = $conn->prepare("SELECT * FROM users WHERE email = ? AND password = ?");
    $stmt->bind_param("ss", $email, $password);
    $stmt->execute();
    $result = $stmt->get_result();
    if ($result->num_rows > 0) {
        return true; // User exists
    } else {
        return false; // User does not exist or invalid credentials
    }
}


if($_SERVER["REQUEST_METHOD"] == 'GET'){
    $h = apache_request_headers();
    $conn = db_connect();
    $id = $_GET['id'];
    $query = $conn->prepare('SELECT * FROM users WHERE user_id = ?');
    $query->bind_param('i', $id);
    $query->execute();
    $result = $query->get_result();
    if ($result->num_rows > 0) {
        $users = $result->fetch_assoc();
        $email = $users['email'];
        $access_token = create_access_token($conn, $email);
        header('x-auth-token:'.$access_token);
        http_response_code(200);
        echo json_encode($users);
    }else{
        http_response_code(404);
        echo json_encode(array('error'=>'Not Found'));
    }
}

// Check if form is submitted
if ($_SERVER["REQUEST_METHOD"] == "POST"){
    $conn = db_connect();
    $raw_post_data = file_get_contents("php://input");
    
    // Display the raw POST data
    $raw_post_data = json_decode($raw_post_data, true);
    $email = $raw_post_data["email"];
    $password = $raw_post_data["password"];
    header('Content-Type: application/json');
    if (authenticate_user($conn, $email, $password)) {
        // User authenticated successfully, redirect to dashboard or home page
        $access_token = create_access_token($conn, $email);
        header('Authorization:'.$access_token);
        http_response_code(200);

        echo json_encode(decode_access_token($access_token));
    } else {
        http_response_code(401);
        echo json_encode(array('error'=>'Invalid username or password.'));
    }

    $conn->close();
}
