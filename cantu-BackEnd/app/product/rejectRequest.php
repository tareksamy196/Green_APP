<?php
require '../../accesstoken.php';
require '../../connect.php';

if ($_SERVER["REQUEST_METHOD"] == 'GET') {
    $id = intval($_GET['request_id']);
    $employee_id = 1;
    $headers = apache_request_headers();
    $token = $headers['Authorization'] ?? '';
    header('Content-Type: application/json');
    if (empty($token)) {
        http_response_code(401);
        echo json_encode(array("error" => "Missing access token."));
        exit;
    }

    $user_access = decode_access_token($token);
    $user = json_decode($user_access, true);
    if (is_array($user) && isset($user['id'])) {
        $employee_id = $user['id'];
    } else {
        http_response_code(401);
        echo json_encode(array("error" => "Invalid access token"));
        exit;
    }

    $conn = db_connect();
    
    // Log the input values
    error_log("Updating request ID: $id by employee ID: $employee_id");

    // Prepare the update statement
    $sql = "UPDATE product_request SET status = 'rejected', reviewed_by = '$employee_id' WHERE id = '$id'";

    $stmt = $conn->prepare($sql);



    // Execute the statement
    if ($stmt->execute()) {
        error_log("Affected rows: " . $stmt->affected_rows);
        if ($conn->query($sql) === TRUE) {
            http_response_code(200);
            echo json_encode(array("message" => "Request rejected"));
        } else {
            http_response_code(404);
            echo json_encode(array("error" => "No product request found with the given ID."));
        }
    } else {
        http_response_code(500);
        echo json_encode(array("error" => "Failed to update product request."));
    }

    // Close the connection
    $conn->close();
}
?>
