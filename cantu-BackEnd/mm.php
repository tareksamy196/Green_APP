<?php
// Include the database connection script
require '../../connect.php';

// Function to sanitize user input
function sanitize_input($input) {
    $input = trim($input);
    $input = stripslashes($input);
    $input = htmlspecialchars($input);
    return $input;
}

// Function to retrieve products by category
function get_products_by_category($conn, $category_id) {
    $category_id = sanitize_input($category_id);

    $stmt = $conn->prepare("SELECT * FROM product WHERE category_idcategory = ?");
    $stmt->bind_param("i", $category_id);
    $stmt->execute();
    $result = $stmt->get_result();
    
    $products = array();
    while ($row = $result->fetch_assoc()) {
        $products[] = $row;
    }
    
    return $products;
}

// Handle GET request
if ($_SERVER["REQUEST_METHOD"] == "GET") {
    // Establish database connection
    $conn = db_connect();

    // Retrieve category ID from the URL
    $category_id = isset($_GET['category_idcategory']) ? $_GET['category_idcategory'] : null;

    if ($category_id !== null) {
        // Retrieve products by category
        $products = get_products_by_category($conn, $category_id);

        if (!empty($products)) {
            // Respond with products in JSON format
            http_response_code(200);
            echo json_encode($products);
        } else {
            // No products found for the specified category
            http_response_code(404);
            echo json_encode(array('error' => 'No products found for this category.'));
        }
    } else {
        // Category ID is missing from the URL
        http_response_code(400);
        echo json_encode(array('error' => 'Category ID is required.'));
    }

    // Close database connection
    $conn->close();
}
?>
