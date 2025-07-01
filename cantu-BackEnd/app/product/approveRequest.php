<?php
require '../../accesstoken.php';
require '../../connect.php';

if ($_SERVER["REQUEST_METHOD"] == 'GET') {
    $id = intval($_GET['request_id']);
    $employee_id = 1;
    $headers = apache_request_headers();
    $token = $headers['Authorization'] ?? '';
    header('Content-Type: application/json');
    if (empty($token)) {
        http_response_code(401);
        echo json_encode(array("error" => "Missing access token."));
        exit;
    }

    $user_access = decode_access_token($token);
    $user = json_decode($user_access, true);
    if (is_array($user) && isset($user['id'])) {
        $employee_id = $user['id'];
    } else {
        http_response_code(401);
        echo json_encode(array("error" => "Invalid access token"));
        exit;
    }

    $conn = db_connect();
    
    // Log the input values
    error_log("Updating request ID: $id by employee ID: $employee_id");

    // Prepare the update statement
    $sql = "UPDATE product_request SET status = 'approved', reviewed_by = '$employee_id' WHERE id = '$id'";

    $stmt = $conn->prepare($sql);



    // Execute the statement
    if ($stmt->execute()) {
        error_log("Affected rows: " . $stmt->affected_rows);
        if ($conn->query($sql) === TRUE) {
            // Prepare a select statement to get the updated request
            $stmt = $conn->prepare("SELECT * FROM product_request WHERE id = ?");
            if ($stmt === false) {
                http_response_code(500);
                echo json_encode(array("error" => "Failed to prepare the select statement."));
                exit;
            }
            $stmt->bind_param("i", $id);
            $stmt->execute();
            $result = $stmt->get_result();

            if ($result->num_rows > 0) {
                $row = $result->fetch_assoc();
                $seller_id = $row['user_id'];
                $request_id = $row['id'];
                $category = $row['category_id'];
                $brand = $row['brand_id'];
                $name = $row['name'];
                $price = $row['price'];
                $quantity = $row['quantity'];
                $pic = $row['pic'];
                $conn = db_connect();
                $stmt =$conn->prepare("INSERT INTO product (seller_id,request_id,name, category_id, brand_id, price,quantity, pic) VALUES ('$seller_id','$request_id','$name','$category','$brand','$price','$quantity','$pic')");
                if ($stmt === false) {
                    http_response_code(500);
                    echo json_encode(array("error" => "Failed to prepare the insert statement."));
                    exit;
                }
                
                if ($stmt->execute()) {
                    $product_id = $stmt->insert_id;
                    http_response_code(200);
                    echo json_encode(['message' => 'Product created successfully', 'product_id' => $product_id]);
                } else {
                    http_response_code(400);
                    echo json_encode(['error' => 'Failed to create product']);
                }

                $stmt->close();
            } else {
                http_response_code(404);
                echo json_encode(array("error" => "No product request found."));
            }
        } else {
            http_response_code(404);
            echo json_encode(array("error" => "No product request found with the given ID."));
        }
    } else {
        http_response_code(500);
        echo json_encode(array("error" => "Failed to update product request."));
    }

    // Close the connection
    $conn->close();
}
?>
