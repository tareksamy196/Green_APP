<?php
require '../../accesstoken.php';
require '../../connect.php';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $data = json_decode(file_get_contents('php://input'), true);
    if (!isset($data['product_id']) || !isset($data['quantity'])) {
        http_response_code(400);
        echo json_encode(['error' => 'Invalid input']);
        exit;
    }

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
    
    if ($conn->connect_error) {
        http_response_code(500);
        echo json_encode(['error' => 'Database connection failed: ' . $conn->connect_error]);
        exit;
    }
    
    // Check if the user has an existing cart
    $stmt = $conn->prepare("SELECT id FROM cart WHERE user_id = ?");
    if (!$stmt) {
        http_response_code(500);
        echo json_encode(['error' => 'Failed to prepare statement: ' . $conn->error]);
        exit;
    }
    $stmt->bind_param("i", $user_id);
    $stmt->execute();
    $result = $stmt->get_result();
    $cart_id = 0;
    if ($result->num_rows > 0) {
        $row = $result->fetch_assoc();
        $cart_id = $row['id'];
    } else {
        // Create a new cart for the user
        $stmt = $conn->prepare("INSERT INTO cart (user_id) VALUES (?)");
        if (!$stmt) {
            http_response_code(500);
            echo json_encode(['error' => 'Failed to prepare statement: ' . $conn->error]);
            exit;
        }
        $stmt->bind_param("i", $user_id);
        $stmt->execute();
        $cart_id = $stmt->insert_id;
    }

    // Add product to the cart or update the quantity if it already exists
    $stmt = $conn->prepare("SELECT id FROM cart_item WHERE cart_id = ? AND product_id = ?");
    if (!$stmt) {
        http_response_code(500);
        echo json_encode(['error' => 'Failed to prepare statement: ' . $conn->error]);
        exit;
    }
    $stmt->bind_param("ii", $cart_id, $product_id);
    $stmt->execute();
    $result = $stmt->get_result();
    if ($result->num_rows > 0) {
        $stmt = $conn->prepare("UPDATE cart_item SET quantity = ? WHERE cart_id = ? AND product_id = ?");
        if (!$stmt) {
            http_response_code(500);
            echo json_encode(['error' => 'Failed to prepare statement: ' . $conn->error]);
            exit;
        }
        $stmt->bind_param("iii", $quantity, $cart_id, $product_id);
    } else {
        $stmt = $conn->prepare("INSERT INTO cart_item (cart_id, product_id, quantity) VALUES (?, ?, ?)");
        if (!$stmt) {
            http_response_code(500);
            echo json_encode(['error' => 'Failed to prepare statement: ' . $conn->error]);
            exit;
        }
        $stmt->bind_param("iii", $cart_id, $product_id, $quantity);
    }
    
    if ($stmt->execute()) {
        http_response_code(200);
        echo json_encode(['message' => 'Product added to cart successfully']);
    } else {
        http_response_code(400);
        echo json_encode(['error' => 'Failed to add product to cart: ' . $stmt->error]);
    }

    $stmt->close();
    $conn->close();
} else {
    http_response_code(400);
    echo json_encode(['error' => 'Invalid request method']);
}
?>
