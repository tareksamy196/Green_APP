<?php
require '../../connect.php';

// Function to sanitize user input
function sanitize_input($input) {
    $input = trim($input);
    $input = stripslashes($input);
    $input = htmlspecialchars($input);
    return $input;
}

// Function to add a product to the user's cart
function add_product_to_cart($conn, $user_id, $product_id, $quantity) {
    $user_id = sanitize_input($user_id);
    $product_id = sanitize_input($product_id);
    $quantity = sanitize_input($quantity);

    // Check if the product is already in the user's cart
    $stmt = $conn->prepare("SELECT * FROM cart WHERE user_id = ? AND product_id = ?");
    $stmt->bind_param("ii", $user_id, $product_id);
    $stmt->execute();
    $result = $stmt->get_result();

    if ($result->num_rows > 0) {
        // Update the quantity if the product is already in the cart
        $row = $result->fetch_assoc();
        $existing_quantity = $row['quantity'];
        $new_quantity = $existing_quantity + $quantity;

        $stmt = $conn->prepare("UPDATE cart SET quantity = ? WHERE user_id = ? AND product_id = ?");
        $stmt->bind_param("iii", $new_quantity, $user_id, $product_id);
        $stmt->execute();
    } else {
        // Insert a new entry if the product is not in the cart
        $stmt = $conn->prepare("INSERT INTO cart (user_id, product_id, quantity) VALUES (?, ?, ?)");
        $stmt->bind_param("iii", $user_id, $product_id, $quantity);
        $stmt->execute();
    }
}

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $conn = db_connect();
    $raw_post_data = file_get_contents("php://input");
    $raw_post_data = json_decode($raw_post_data, true);
    
    // Extracting user ID, product ID, and quantity from POST data
    $user_id = $raw_post_data["user_id"];
    $product_id = $raw_post_data["product_id"];
    $quantity = $raw_post_data["quantity"];

    // Adding the product to the user's cart
    add_product_to_cart($conn, $user_id, $product_id, $quantity);

    http_response_code(200);
    echo json_encode(array('message' => 'Product added to cart successfully.'));
    
    $conn->close();
}
