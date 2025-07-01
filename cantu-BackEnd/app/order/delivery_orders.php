<?php
require '../../connect.php';

if ($_SERVER['REQUEST_METHOD'] === 'GET') {
    $conn = db_connect();
    // Get user orders
    $stmt = $conn->prepare("SELECT o.id, o.total_amount, o.status, o.created_at FROM `order` o WHERE o.status != 'delivered'");
    $stmt->execute();
    $result = $stmt->get_result();
    
    $orders = array();
    while ($row = $result->fetch_assoc()) {
        $orders[] = $row;
    }
    
    http_response_code(200);
    echo json_encode(['orders' => $orders]);
    
    $stmt->close();
    $conn->close();
} else {
    http_response_code(400);
    echo json_encode(['error' => 'Invalid request method']);
}
?>
