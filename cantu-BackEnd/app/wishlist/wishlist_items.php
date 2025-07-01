<?php
require '../../connect.php';
require '../../accesstoken.php';

if ($_SERVER["REQUEST_METHOD"] == 'GET') {
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
    $wishlist_id = 0;
    
    if (is_array($user) && isset($user['id'])) {
        $user_id = $user['id'];
    } else {
        http_response_code(401);
        echo json_encode(array("error" => "Invalid access token"));
        exit;
    }
    
    $conn = db_connect();
    $stmt = $conn->prepare("SELECT wishlist_id FROM users_has_wishlist WHERE users_id = ?");
    $stmt->bind_param("i", $user_id);
    $stmt->execute();
    $result = $stmt->get_result();
    
    // Check if there are any results
    if ($result->num_rows > 0) {
        $row = $result->fetch_assoc();
        $wishlist_id = $row['wishlist_id'];
    } else {
        http_response_code(404);
        echo json_encode(array("error" => "Wishlist Not Found"));
        exit;
    }
    
    $stmt = $conn->prepare("
        SELECT 
            wp.product_id, 
            p.name, 
            p.description, 
            p.price, 
            p.pic 
        FROM wishlist_has_product wp 
        JOIN product p ON wp.product_id = p.id 
        WHERE wp.wishlist_id = ?
    ");
    $stmt->bind_param("i", $wishlist_id);
    $stmt->execute();
    $result = $stmt->get_result();
    
    if ($result->num_rows > 0) {
        $wishlist_items = array();
        
        while ($row = $result->fetch_assoc()) {
            $wishlist_items[] = $row;
        }
        
        http_response_code(200);
        echo json_encode(array("wishlist_items" => $wishlist_items));
    } else {
        http_response_code(404);
        echo json_encode(array("error" => "No items found in wishlist"));
    }
    
    $stmt->close();
    $conn->close();
}
?>
