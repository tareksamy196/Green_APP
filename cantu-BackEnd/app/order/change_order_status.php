<?php
require '../../accesstoken.php';
require '../../connect.php';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $headers = apache_request_headers();
    $token = $headers['Authorization'];
    header('Content-Type: application/json');
    
    if (empty($token)) {
        http_response_code(401);
        echo json_encode(array("error" => "Missing access token."));
        exit;
    }
    
    $user_access = decode_access_token($token);
    $user = json_decode($user_access, true);
    $user_id = 0;
    
    if (is_array($user) && isset($user['id'])) {
        $user_id = $user['id'];
    } else {
        http_response_code(401);
        echo json_encode(array("error" => "Invalid access token"));
        exit;
    }
    
    if ($user['is_employee'] == 0) {
        http_response_code(403);
        echo json_encode(array("error" => "Unauthorized"));
        exit;
    }
    
    $order_id = intval($_POST['order_id']);
    $action = $_POST['action'];
    
    $conn = db_connect();
    
    if ($action === 'in progress') {
        $new_status = 'in progress';
    } elseif ($action === 'delivered') {
        $new_status = 'delivered';
    } else {
        http_response_code(400);
        echo json_encode(array("error" => "Invalid action"));
        exit;
    }
    
    $stmt = $conn->prepare("UPDATE `order` SET status = ? WHERE id = ?");
    $stmt->bind_param("si", $new_status, $order_id);
    
    if ($stmt->execute()) {
        http_response_code(200);
        echo json_encode(array("message" => "Order status updated successfully"));
    } else {
        http_response_code(500);
        echo json_encode(array("error" => "Failed to update order status"));
    }
    
    $stmt->close();
    $conn->close();
} else {
    http_response_code(400);
    echo json_encode(array("error" => "Invalid request method"));
}
?>
