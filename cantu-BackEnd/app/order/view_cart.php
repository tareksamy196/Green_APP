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
    // Check if user has a cart
    $stmt = $conn->prepare("SELECT id FROM cart WHERE user_id = ?");
    $stmt->bind_param("i", $user_id);
    $stmt->execute();
    $result = $stmt->get_result();
    $cart_id = 0;
    if ($result->num_rows > 0) {
        $row = $result->fetch_assoc();
        $cart_id = $row['id'];
    } else {
        http_response_code(404);
        echo json_encode(['error' => 'Cart not found']);
        exit;
    }
    // Get cart items with detailed product information
    $stmt = $conn->prepare("SELECT ci.*, p.name, p.description, p.price, p.pic FROM cart_item ci JOIN product p ON ci.product_id = p.id WHERE ci.cart_id = ?");
    $stmt->bind_param("i", $cart_id);
    $stmt->execute();
    $result = $stmt->get_result();
    
    $cart_items = array();
    while ($row = $result->fetch_assoc()) {
        $cart_items[] = $row;
    }
    
    http_response_code(200);
    echo json_encode(['cart_items' => $cart_items]);
    
    $stmt->close();
    $conn->close();
} else {
    http_response_code(400);
    echo json_encode(['error' => 'Invalid request method']);
}
?>
