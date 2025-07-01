<?php
require '../../connect.php';

// Function to sanitize user input
function sanitize_input($input) {
    $input = trim($input);
    $input = stripslashes($input);
    $input = htmlspecialchars($input);
    return $input;
}

// Function to delete a product from the user's cart
function delete_product_from_cart($conn, $user_id, $product_id) {
    $user_id = sanitize_input($user_id);
    $product_id = sanitize_input($product_id);

    $stmt = $conn->prepare("DELETE FROM cart WHERE user_id = ? AND product_id = ?");
    $stmt->bind_param("ii", $user_id, $product_id);
    $stmt->execute();
    $stmt->close();
}

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $conn = db_connect();
    $raw_post_data = file_get_contents("php://input");
    $raw_post_data = json_decode($raw_post_data, true);
    
    // Extracting user ID and product ID from POST data
    $user_id = $raw_post_data["user_id"];
    $product_id = $raw_post_data["product_id"];

    // Deleting the product from the user's cart
    delete_product_from_cart($conn, $user_id, $product_id);

    http_response_code(200);
    echo json_encode(array('message' => 'Product deleted from cart successfully.'));
    
    $conn->close();
}
