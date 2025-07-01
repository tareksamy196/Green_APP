<?php
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

require '../../connect.php';

if ($_SERVER["REQUEST_METHOD"] == 'GET') {
    $id = isset($_GET['product_id']) ? intval($_GET['product_id']) : 0;
    if ($id == 0) {
        http_response_code(400);
        echo json_encode(array("error" => "Invalid product ID."));
        exit;
    }

    $conn = db_connect();
    if ($conn->connect_error) {
        http_response_code(500);
        echo json_encode(array("error" => "Connection failed: " . $conn->connect_error));
        exit;
    }

    $stmt = $conn->prepare("
        SELECT 
            p.*, 
            c.name as category_name,
            c.pic as category_pic,
            b.name as brand_name
        FROM 
            product p
        LEFT JOIN 
            category c ON p.category_id = c.id
        LEFT JOIN 
            brand b ON p.brand_id = b.id
        WHERE 
            p.id = ?
    ");

    if (!$stmt) {
        http_response_code(500);
        echo json_encode(array("error" => "SQL preparation error: " . $conn->error));
        exit;
    }

    $stmt->bind_param("i", $id);
    $stmt->execute();
    $result = $stmt->get_result();

    header('Content-Type: application/json');
    if ($result->num_rows > 0) {
        http_response_code(200);
        echo json_encode($result->fetch_assoc());
    } else {
        http_response_code(404);
        echo json_encode(array("error" => "No product found."));
    }

    $stmt->close();
    $conn->close();
}
?>
