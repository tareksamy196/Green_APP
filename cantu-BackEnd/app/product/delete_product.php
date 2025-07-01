<?php
require '../../connect.php';

// Function to sanitize user input
function sanitize_input($input) {
    $input = trim($input);
    $input = stripslashes($input);
    $input = htmlspecialchars($input);
    return $input;
}

// Function to delete a product
function delete_product($conn, $product_id) {
    $product_id = sanitize_input($product_id);

    $stmt = $conn->prepare("DELETE FROM product WHERE id = ?");
    $stmt->bind_param("i", $product_id);
    $stmt->execute();
    $stmt->close();
}

// Handle DELETE request
if ($_SERVER["REQUEST_METHOD"] == "DELETE") {
    $conn = db_connect();
    $raw_input = file_get_contents("php://input");
    $data = json_decode($raw_input, true);

    // Check if the product ID is provided
    if (isset($data["product_id"])) {
        $product_id = $data["product_id"];

        // Delete the product from the database
        delete_product($conn, $product_id);

        http_response_code(200);
        echo json_encode(array('message' => 'Product deleted successfully.'));
    } else {
        // Product ID not provided
        http_response_code(400);
        echo json_encode(array('error' => 'Product ID not provided.'));
    }

    $conn->close();
}
?>
