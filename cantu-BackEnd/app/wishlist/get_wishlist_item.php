<?php
require '../../connect.php';
require '../../accesstoken.php';

if ($_SERVER["REQUEST_METHOD"] == 'GET') {
    $id = intval($_GET['product_id']);
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
    $user_id = 0;
    $wishlist_id = 0;
    if(is_array($user) && isset($user['id'])){
        $user_id = $user['id'];
    }else{
        http_response_code(401);
        echo json_encode(array("error" => "Invalid access token"));
        exit;
    }
    $conn = db_connect();
    $stmt = $conn->prepare("SELECT * FROM users_has_wishlist WHERE users_id = ?");
    $stmt->bind_param("i", $user_id);
    $stmt->execute();
    $result = $stmt->get_result();
    // Check if there are any results
    if ($result->num_rows > 0) {
        // Fetch data from the result set
        $row = $result->fetch_assoc();
    
        // Access the data
        $wishlist_id = $row['wishlist_id'];
        $user_id = $row['users_id'];
       
    }else{
        header('Content-Type: application/json');
        http_response_code(404);
        echo json_encode(array("error" => "Wishlist Not Found"));
        exit;
    }
    $stmt = $conn->prepare("SELECT * FROM wishlist_has_product WHERE wishlist_id = ? AND product_id = ?");
    $stmt->bind_param("ii", $wishlist_id,$id);
    $stmt->execute();
    $result = $stmt->get_result();
    header('Content-Type: application/json');
    if($result->num_rows > 0){
        http_response_code(200);
        echo json_encode(array("message" => "Done"));
    }else{
        http_response_code(404);
        echo json_encode(array("error" => "Not Found"));

    }
    $stmt->close();
    $conn->close();
    
}
?>
