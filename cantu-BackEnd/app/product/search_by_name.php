<?php
require '../../connect.php';

header('Content-Type: application/json');

if ($_SERVER["REQUEST_METHOD"] == 'GET') {
    $conn = db_connect();

    if (!$conn) {
        http_response_code(500);
        echo json_encode(array("error" => "Database connection failed: " . mysqli_connect_error()));
        exit;
    }

    if (isset($_GET['query'])) {
        $query = $_GET['query'];
        $stmt = $conn->prepare("SELECT * FROM product WHERE name LIKE ?");
        $like_query = "%" . $query . "%";
        $stmt->bind_param("s", $like_query);
    } else {
        // If no query is provided, return all products
        $stmt = $conn->prepare("SELECT * FROM product");
    }

    $stmt->execute();
    $result = $stmt->get_result();

    $products = array();
    while ($row = $result->fetch_assoc()) {
        $products[] = $row;
    }

    if (empty($products)) {
        http_response_code(404);
        echo json_encode(array("message" => "No products found."));
    } else {
        http_response_code(200);
        echo json_encode($products);
    }

    $stmt->close();
    $conn->close();
} else {
    http_response_code(400);
    echo json_encode(array("error" => "Invalid request method"));
}
?>
