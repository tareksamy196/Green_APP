<?php
// Enable error reporting for debugging
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

require '../../accesstoken.php';
require '../../connect.php';

if ($_SERVER["REQUEST_METHOD"] == 'GET') {
    $conn = db_connect();
    
    if ($conn->connect_error) {
        http_response_code(500);
        echo json_encode(array("error" => "Connection failed: " . $conn->connect_error));
        exit;
    }
    
    $stmt = $conn->prepare("
        SELECT 
            pr.*, 
            c.name as category_name, 
            b.name as brand_name, 
            u.name as user_name
        FROM 
            product_request pr
        LEFT JOIN 
            category c ON pr.category_id = c.id
        LEFT JOIN 
            brand b ON pr.brand_id = b.id
        LEFT JOIN 
            users u ON pr.user_id = u.id
        WHERE 
            pr.status = 'pending'
    ");// if you want all requests remove last filter

    if (!$stmt) {
        http_response_code(500);
        echo json_encode(array("error" => "SQL preparation error: " . $conn->error));
        exit;
    }

    $stmt->execute();
    $result = $stmt->get_result();

    if ($result === false) {
        http_response_code(500);
        echo json_encode(array("error" => "Execution error: " . $stmt->error));
        exit;
    }

    $products = array();
    while ($row = $result->fetch_assoc()) {
        $products[] = $row;
    }

    header('Content-Type: application/json');
    if (empty($products)) {
        http_response_code(404);
        echo json_encode(array("error" => "No requests found."));
    } else {
        http_response_code(200);
        echo json_encode($products);
    }

    $stmt->close();
    $conn->close();
}
?>