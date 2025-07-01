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
    
    // Check if order_id is provided
    if (isset($_GET['order_id'])) {
        $order_id = intval($_GET['order_id']);
        
        // Get specific order details
        $stmt = $conn->prepare("SELECT * FROM `order` WHERE id = ?");
        $stmt->bind_param("i", $order_id);
        $stmt->execute();
        $result = $stmt->get_result();
        
        if ($result->num_rows > 0) {
            $order = $result->fetch_assoc();
            
            // Get order items with product details
            $stmt = $conn->prepare("SELECT oi.product_id, oi.quantity, oi.price, p.name, p.description,p.pic, p.price as product_price FROM order_item oi JOIN product p ON oi.product_id = p.id WHERE oi.order_id = ?");
            $stmt->bind_param("i", $order_id);
            $stmt->execute();
            $items_result = $stmt->get_result();
            
            $order_items = array();
            while ($item_row = $items_result->fetch_assoc()) {
                $order_items[] = $item_row;
            }
            
            $order['items'] = $order_items;
            
            http_response_code(200);
            echo json_encode(['order' => $order]);
        } else {
            http_response_code(404);
            echo json_encode(['error' => 'Order not found']);
        }
    } else {
        // Get all user orders
        $stmt = $conn->prepare("SELECT *  FROM `order` WHERE user_id = ?");
        $stmt->bind_param("i", $user_id);
        $stmt->execute();
        $result = $stmt->get_result();
        
        $orders = array();
        while ($row = $result->fetch_assoc()) {
            $orders[] = $row;
        }
        
        http_response_code(200);
        echo json_encode(['orders' => $orders]);
    }
    
    $stmt->close();
    $conn->close();
} else {
    http_response_code(400);
    echo json_encode(['error' => 'Invalid request method']);
}
?>
