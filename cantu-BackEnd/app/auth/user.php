<?php
require '../../accesstoken.php'; // Include the Composer autoloader
require '../../connect.php';


if($_SERVER["REQUEST_METHOD"] == 'GET'){
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
        $conn = db_connect();
        $id = $user['id'];
        $query = $conn->prepare('SELECT * FROM users WHERE id = ?');
        $query->bind_param('i', $id);
        $query->execute();
        $result = $query->get_result();
        if ($result->num_rows > 0) {
            $users = $result->fetch_assoc();
            $email = $users['email'];
            $access_token = create_access_token($conn, $email);
            header('Authorization:'.$access_token);
            http_response_code(200);
            echo json_encode($users);
        }else{
            http_response_code(404);
            echo json_encode(array('error'=>'Not Found'));
        }
        $conn->close();
    }else{
        http_response_code(401);
        echo json_encode(array("error" => "Invalid access token"));
        exit;
    }
    
}
