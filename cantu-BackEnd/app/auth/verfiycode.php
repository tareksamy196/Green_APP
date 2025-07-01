<?php
require '../../connect.php';

// Function to sanitize user input
function sanitize_input($input) {
    $input = trim($input);
    $input = stripslashes($input);
    $input = htmlspecialchars($input);
    return $input;
}

// Function to generate a random verification code
function generate_verification_code($length = 6) {
    return rand(pow(10, $length-1), pow(10, $length)-1);
}

// Function to update the verification code in the database
function update_verification_code($conn, $email, $verification_code) {
    $email = sanitize_input($email);
    $verification_code = sanitize_input($verification_code);

    $stmt = $conn->prepare("UPDATE users SET verification_code = ? WHERE email = ?");
    $stmt->bind_param("ss", $verification_code, $email);
    $stmt->execute();
    $stmt->close();
}

// Function to send verification code to the user's email
function send_verification_code($email, $verification_code) {
    // Code to send email with verification code
    // Example: mail($email, "Verification Code", "Your verification code is: $verification_code");
    // Make sure to configure your mail server or use a third-party service for sending emails
}

// Function to verify user with provided verification code
function verify_user($conn, $email, $verification_code) {
    $email = sanitize_input($email);
    $verification_code = sanitize_input($verification_code);

    $stmt = $conn->prepare("SELECT * FROM users WHERE email = ? AND verification_code = ?");
    $stmt->bind_param("ss", $email, $verification_code);
    $stmt->execute();
    $result = $stmt->get_result();
    if ($result->num_rows > 0) {
        // User verified successfully
        $stmt->close();
        return true;
    } else {
        // Invalid verification code
        $stmt->close();
        return false;
    }
}

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $conn = db_connect();
    $raw_post_data = file_get_contents("php://input");
    $raw_post_data = json_decode($raw_post_data, true);
    $email = $raw_post_data["email"];
    
    // Generate and update verification code in the database
    $verification_code = generate_verification_code();
    update_verification_code($conn, $email, $verification_code);
    
    // Send verification code to the user's email
    send_verification_code($email, $verification_code);

    http_response_code(200);
    echo json_encode(array('message' => 'Verification code sent successfully.'));
    
    $conn->close();
}
