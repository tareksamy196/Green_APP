<?php
require '../../accesstoken.php';
require '../../connect.php';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
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
    
    // Check if user has a cart
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
    
    // Calculate total amount
    $stmt = $conn->prepare("SELECT SUM(ci.quantity * p.price) as total_amount FROM cart_item ci JOIN product p ON ci.product_id = p.id WHERE ci.cart_id = ?");
    $stmt->bind_param("i", $cart_id);
    $stmt->execute();
    $result = $stmt->get_result();
    $total_amount = $result->fetch_assoc()['total_amount'];
    
    // Create order
    $stmt = $conn->prepare("INSERT INTO `order` (user_id, total_amount, status) VALUES (?, ?, 'pending')");
    $stmt->bind_param("id", $user_id, $total_amount);
    
    try {
        if ($stmt->execute()) {
            $order_id = $stmt->insert_id;
            
            // Add items to order
            $stmt = $conn->prepare("INSERT INTO order_item (order_id, product_id, quantity, price) SELECT ?, ci.product_id, ci.quantity, p.price FROM cart_item ci JOIN product p ON ci.product_id = p.id WHERE ci.cart_id = ?");
            $stmt->bind_param("ii", $order_id, $cart_id);
            $stmt->execute();
            
            // Clear cart items
            $stmt = $conn->prepare("DELETE FROM cart_item WHERE cart_id = ?");
            $stmt->bind_param("i", $cart_id);
            $stmt->execute();
            
            http_response_code(200);
            echo json_encode(['message' => 'Order created successfully', 'order_id' => $order_id]);
        } else {
            http_response_code(400);
            echo json_encode(['error' => 'Failed to create order']);
        }
    } catch (PDOException $e) {
        http_response_code(500);
        echo "Error: " . $e->getMessage();
    }
    
    $stmt->close();
    $conn->close();
} else {
    http_response_code(400);
    echo json_encode(['error' => 'Invalid request method']);
}
?>

