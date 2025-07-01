<?php
require '../../accesstoken.php';
require '../../connect.php';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $data = json_decode(file_get_contents('php://input'), true);
    if (!isset($data['action']) || !isset($data['product_id']) || !isset($data['quantity'])) {
        http_response_code(400);
        echo json_encode(['error' => 'Invalid input']);
        exit;
    }

    $action = $data['action'];
    $product_id = $data['product_id'];
    $quantity = $data['quantity'];
    $headers = apache_request_headers();
    $token = $headers['Authorization'];
    
    if (empty($token)) {
        http_response_code(401);
        echo json_encode(['error' => 'Missing access token']);
        exit;
    }

    $user_access = decode_access_token($token);
    $user = json_decode($user_access, true);
    
    if (!is_array($user) || !isset($user['id'])) {
        http_response_code(401);
        echo json_encode(['error' => 'Invalid access token']);
        exit;
    }

    $user_id = $user['id'];
    $conn = db_connect();
    
    // Check if the user has an existing cart
    $stmt = $conn->prepare("SELECT id FROM cart WHERE user_id = ?");
    $stmt->bind_param("i", $user_id);
    $stmt->execute();
    $result = $stmt->get_result();
    
    if ($result->num_rows > 0) {
        $row = $result->fetch_assoc();
        $cart_id = $row['id'];
    } else {
        http_response_code(404);
        echo json_encode(['error' => 'Cart not found']);
        exit;
    }
    
    if ($action == 'update') {
        $stmt = $conn->prepare("UPDATE cart_item SET quantity = ? WHERE cart_id = ? AND product_id = ?");
        $stmt->bind_param("iii", $quantity, $cart_id, $product_id);
    } elseif ($action == 'delete') {
        $stmt = $conn->prepare("DELETE FROM cart_item WHERE cart_id = ? AND product_id = ?");
        $stmt->bind_param("ii", $cart_id, $product_id);
    } else {
        http_response_code(400);
        echo json_encode(['error' => 'Invalid action']);
        exit;
    }
    
    $stmt->execute();
    if ($stmt->affected_rows > 0) {
        http_response_code(200);
        echo json_encode(['message' => 'Cart updated successfully']);
    } else {
        http_response_code(404);
        echo json_encode(['error' => 'No cart item found or updated']);
    }

    $stmt->close();
    $conn->close();
} else {
    http_response_code(400);
    echo json_encode(['error' => 'Invalid request method']);
}
?>
