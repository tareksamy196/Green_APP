<?php
require '../../accesstoken.php';
require '../../connect.php';

if($_SERVER["REQUEST_METHOD"] == 'GET'){
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
        echo json_encode(array("error" => "No products found."));
    } else {
        http_response_code(200);
        echo json_encode($products);
    }
    $stmt->close();
    $conn->close();
}