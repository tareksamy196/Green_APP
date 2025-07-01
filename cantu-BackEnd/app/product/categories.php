<?php
require '../../accesstoken.php';
require '../../connect.php';

if($_SERVER["REQUEST_METHOD"] == 'GET'){
    $conn = db_connect();
    $stmt = $conn->prepare("SELECT * FROM category");
    $stmt->execute();
    $result = $stmt->get_result();
    $categories = array();
    while ($row = $result->fetch_assoc()) {
        $categories[] = $row;
    }

    header('Content-Type: application/json');
    if (empty($categories)) {
        http_response_code(404);
        echo json_encode(array("error" => "No categories found."));
    } else {
        http_response_code(200);
        echo json_encode($categories);
    }
    $stmt->close();
    $conn->close();
}