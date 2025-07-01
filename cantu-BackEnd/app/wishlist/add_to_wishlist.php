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
    } else {
        // No whichlist found, Create one!
    
        $stmt =$conn->prepare("INSERT INTO wishlist () VALUES ()");
        try{
            if ($stmt->execute()) {
                $wishlist_id = $stmt->insert_id;
                $stmt =$conn->prepare("INSERT INTO users_has_wishlist (wishlist_id,users_id) VALUES ('$wishlist_id','$user_id')");
                if($stmt->execute()){

                }else{
                    http_response_code(400);
                    echo json_encode(['error' => 'Failed to create whichlist']);
                    exit;
                }
            } else {
                http_response_code(400);
                echo json_encode(['error' => 'Failed to create whichlist']);
                exit;
            }
        } catch(PDOException $e) {
            http_response_code(500);
            echo "Error: " . $e->getMessage();
        }
       
    }
    $isAdded = false;
    //check if product exist
    $stmt = $conn->prepare("SELECT * FROM product WHERE id = ?");
    $stmt->bind_param("i", $id);
    $stmt->execute();
    $result = $stmt->get_result();
    // Check if there are any results
    if ($result->num_rows > 0) {
        //check if a product is in the wich list
        $stmt = $conn->prepare("SELECT * FROM wishlist_has_product WHERE wishlist_id = ? AND product_id = ?");
        $stmt->bind_param("ii", $wishlist_id,$id);
        $stmt->execute();
        $result = $stmt->get_result();
        if($result->num_rows > 0){
            $isAdded = TRUE;
        }else{
            $isAdded = FALSE;
        }
    }else{
        http_response_code(404);
        echo json_encode(array("error" => "No product found.")); 
        exit;
    }

    header('Content-Type: application/json');
    if ($isAdded) {
        http_response_code(400);
        echo json_encode(array("error" => "Already Added"));
    } else {
        $stmt =$conn->prepare("INSERT INTO wishlist_has_product (wishlist_id,product_id) VALUES ('$wishlist_id','$id')");
        try{
            if ($stmt->execute()) {
                http_response_code(200);
                echo json_encode(array("message" => "item Added"));
            }else{
                http_response_code(500);
                echo json_encode(array("error" => "Faield to add"));
            }
        } catch(PDOException $e) {
            http_response_code(500);
            echo "Error: " . $e->getMessage();
        }
       
    }
    $stmt->close();
    $conn->close();
    
}
?>
