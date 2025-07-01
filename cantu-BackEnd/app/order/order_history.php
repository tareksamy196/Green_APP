<?php
require '../../accesstoken.php';
require '../../connect.php';

if ($_SERVER['REQUEST_METHOD'] === 'GET') {
    $headers = apache_request_headers();
    $token = $headers['Authorization'];
    header('Content-Type: application/json');
    
    if (empty($token)) {
        http_response_code(401);
        echo json_encode(array("error" => "missing access token.".$token));
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
    
    $conn = db_connect();
    
    // Get user orders
    $stmt = $conn->prepare("SELECT o.id, o.total_amount, o.status, o.created_at FROM `order` o WHERE o.user_id = ?");
    $stmt->bind_param("i", $user_id);
    $stmt->execute();
    $result = $stmt->get_result();
    
    $orders = array();
    while ($row = $result->fetch_assoc()) {
        $orders[] = $row;
    }
    
    http_response_code(200);
    echo json_encode(['orders' => $orders]);
    
    $stmt->close();
    $conn->close();
} else {
    http_response_code(400);
    echo json_encode(['error' => 'Invalid request method']);
}
?>
