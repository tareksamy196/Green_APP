<?php
require '../../accesstoken.php';
require '../../connect.php';

if ($_SERVER['REQUEST_METHOD'] === 'GET') {
    if (isset($_GET['categoryId'])) {
        $categoryId = $_GET['categoryId'];
        $conn = db_connect();
        $stmt = $conn->prepare("SELECT * FROM brand WHERE category_id = ?");
        $stmt->bind_param("s", $categoryId);
        $stmt->execute();
        $result = $stmt->get_result();

        $brands = [];
        while ($row = $result->fetch_assoc()) {
            $brands[] = $row;
        }

        echo json_encode($brands);
        $conn->close();
    } else {
        echo json_encode(['error' => 'Category ID not provided']);
    }
} else {
    echo json_encode(['error' => 'Invalid request method']);
}
?>

