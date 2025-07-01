<?php
require '../../connect.php';

if ($_SERVER["REQUEST_METHOD"] == 'GET') {
    $id = intval($_GET['request_id']);
    $conn = db_connect();
    $stmt = $conn->prepare("SELECT * FROM product_request WHERE id = ?");
    $stmt->bind_param("i", $id);
    $stmt->execute();
    $result = $stmt->get_result();

    header('Content-Type: application/json');
    if ($result->num_rows > 0) {
        http_response_code(200);
        echo json_encode($result->fetch_assoc());
    } else {
        http_response_code(404);
        echo json_encode(array("error" => "No request found."));
    }   
    $stmt->close();
    $conn->close();
    
}
?>
