<?php
require '../../accesstoken.php';
require '../../connect.php';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $data = json_decode(file_get_contents('php://input'), true);
    if(isset($data['name']) && isset($data['categoryId']) && isset($data['brandId']) && isset($data['price']) && isset($data['imageUrl']) && isset($data['quantity'])) {
        $name = $data['name'];
        $categoryId = $data['categoryId'];
        $brandId = $data['brandId'];
        $price = $data['price'];
        $imageUrl = $data['imageUrl'];
        $quantity = $data['quantity'];
        $user_id = 1;
        $headers = apache_request_headers();
        $token = $headers['Authorization'];
        header('Content-Type: application/json');
        if (empty($token)) {
            http_response_code(401);
            echo json_encode(array("error" => "missing access token.".$token));
            exit;
        }
        $user_access = decode_access_token($token);
        $user = json_decode($user_access, true);
        if(is_array($user) && isset($user['id'])){
            $user_id = $user['id'];
        }else{
            http_response_code(401);
            echo json_encode(array("error" => "Invalid access token"));
            exit;
        }
        $conn = db_connect();
        $stmt =$conn->prepare("INSERT INTO product_request (user_id,name, category_id, brand_id, price,quantity, pic) VALUES ('$user_id','$name','$categoryId','$brandId','$price','$quantity','$imageUrl')");
        
        try{
            if ($stmt->execute()) {
                $product_id = $stmt->insert_id;
                http_response_code(200);
                echo json_encode(['message' => 'Product created successfully', 'product_id' => $product_id]);
            } else {
                http_response_code(400);
                echo json_encode(['error' => 'Failed to create product']);
            }
        } catch(PDOException $e) {
            http_response_code(500);
            echo "Error: " . $e->getMessage();
        }
        
        $conn->close();
    } else {
        http_response_code(400);
        echo json_encode(['error' => 'Invalid input']);
    }
} else {
    http_response_code(400);
    echo json_encode(['error' => 'Invalid request method']);
}
?>