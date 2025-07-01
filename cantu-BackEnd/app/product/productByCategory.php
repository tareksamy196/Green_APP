<?php
require '../../connect.php';

if ($_SERVER["REQUEST_METHOD"] == 'GET') {
    if (isset($_GET['category_id'])) {
        $category_id = intval($_GET['category_id']);
        $conn = db_connect();
        $stmt = $conn->prepare("SELECT * FROM product WHERE category_id = ?");
        $stmt->bind_param("i", $category_id);
        $stmt->execute();
        $result = $stmt->get_result();

        $products = array();
        while ($row = $result->fetch_assoc()) {
            $products[] = $row;
        }

        header('Content-Type: application/json');
        if (empty($products)) {
            http_response_code(404);
            echo json_encode(array("message" => "No products found in this category."));
        } else {
            http_response_code(200);
            echo json_encode($products);
        }

        $stmt->close();
        $conn->close();
    } else {
        // If no category_id is provided, return all products
        $conn = db_connect();
        $stmt = $conn->prepare("SELECT * FROM product");
        $stmt->execute();
        $result = $stmt->get_result();

        $products = array();
        while ($row = $result->fetch_assoc()) {
            $products[] = $row;
        }

        header('Content-Type: application/json');
        if (empty($products)) {
            http_response_code(404);
            echo json_encode(array("message" => "No products found."));
        } else {
            http_response_code(200);
            echo json_encode($products);
        }

        $stmt->close();
        $conn->close();
    }
}
?>
