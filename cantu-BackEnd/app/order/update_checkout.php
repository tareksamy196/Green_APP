<?php
require '../../accesstoken.php';
require '../../connect.php';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $data = json_decode(file_get_contents('php://input'), true);
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
    
    $address = $data['address'];
    $payment_method = $data['payment_method'];
    $order_id = $data['order_id']; // Assuming order_id is sent from frontend
    
    if (empty($address) || empty($payment_method) || empty($order_id)) {
        http_response_code(400);
        echo json_encode(array("error" => "Address, payment method, and order ID are required"));
        exit;
    }

    $conn = db_connect();
    
    // Update order address
    $stmt = $conn->prepare("UPDATE `order` SET address = ? WHERE id = ? AND user_id = ?");
    $stmt->bind_param("sii", $address, $order_id, $user_id);
    $stmt->execute();

    if ($stmt->affected_rows === 0) {
        http_response_code(404);
        echo json_encode(['error' => 'Order not found for the user or invalid order ID']);
        exit;
    }
    
    // Fetch total amount from order
    $stmt = $conn->prepare("SELECT total_amount FROM `order` WHERE id = ?");
    $stmt->bind_param("i", $order_id);
    $stmt->execute();
    $result = $stmt->get_result();
    
    if ($result->num_rows === 0) {
        http_response_code(404);
        echo json_encode(['error' => 'Order not found']);
        exit;
    }
    
    $order_data = $result->fetch_assoc();
    $total_amount = $order_data['total_amount'];
    
    // Create payment
    $stmt = $conn->prepare("INSERT INTO payment (order_id, amount, method, status, paid_at) VALUES (?, ?, ?, 'approved', CURRENT_TIMESTAMP)");
    $stmt->bind_param("ids", $order_id, $total_amount, $payment_method);
    $stmt->execute();
    
    if ($stmt->affected_rows > 0) {
        // Fetch all items in the order to update product quantities
        $stmt = $conn->prepare("SELECT product_id, quantity FROM order_item WHERE order_id = ?");
        $stmt->bind_param("i", $order_id);
        $stmt->execute();
        $result = $stmt->get_result();

        while ($item = $result->fetch_assoc()) {
            $product_id = $item['product_id'];
            $quantity = $item['quantity'];

            // Update product quantity
            $update_stmt = $conn->prepare("UPDATE product SET quantity = quantity - ? WHERE id = ?");
            $update_stmt->bind_param("ii", $quantity, $product_id);
            $update_stmt->execute();
            $update_stmt->close();
        }

        http_response_code(200);
        echo json_encode(['message' => 'Order updated with new address and payment created successfully', 'order_id' => $order_id]);
    } else {
        http_response_code(400);
        echo json_encode(['error' => 'Failed to create payment']);
    }
    
    $stmt->close();
    $conn->close();
} else {
    http_response_code(400);
    echo json_encode(['error' => 'Invalid request method']);
}
?>
