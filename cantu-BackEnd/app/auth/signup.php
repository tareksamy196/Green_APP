<?php
require '../../accesstoken.php'; // Include the Composer autoloader
require '../../connect.php';

//http request call, will excute inside the if statment block
if ($_SERVER["REQUEST_METHOD"] == "POST"){
    $raw_post_data = file_get_contents("php://input");
    $json = json_decode($raw_post_data, true);
    $username = $json["username"];
    $emailAddress = $json["email"];
    $pass = $json["password"];
    $phoneNumber = $json["phone"];
    // Validate phone number format (optional)
    // Example: Remove non-numeric characters
    header('Content-Type: application/json');
    $phoneNumber = preg_replace('/[^0-9]/', '', $phoneNumber);
    if (!$username  || !$emailAddress || !$pass || !$phoneNumber) {
        http_response_code(400);
        echo json_encode(array('error'=>'Something went wrong.'));
        exit();
    }
    $conn = db_connect();
    //all data is fine
    // Check if the email already exists in the database
    $stmt = $conn->prepare("SELECT * FROM users WHERE email = ?");
    $stmt->bind_param("s", $emailAddress);
    $stmt->execute();
    $result = $stmt->get_result();

    if ($result->num_rows > 0) {
        http_response_code(400);
        echo json_encode(array('error' => 'Email already exists!'));
        exit();
    } else {
        // Check if the phone number already exists
        $stmt = $conn->prepare("SELECT * FROM users WHERE phone = ?");
        $stmt->bind_param("s", $phoneNumber);
        $stmt->execute();
        $result = $stmt->get_result();

        if ($result->num_rows > 0) {
            http_response_code(400); // Set Bad Request status code
            $error_data = array('error' => 'Phone number already exists!');
            echo json_encode($error_data);
            exit();
        }
    
        // Insert user data into the database
        $sql = "INSERT INTO users(name,phone, email, password) VALUES ('$username','$phoneNumber','$emailAddress','$pass')";
      
        if ($conn->query($sql) === TRUE) {
            
            $access_token = create_access_token($conn,$emailAddress);
            header('Authorization:'.$access_token);
            http_response_code(200);
            $data = array('message' => 'Created');
            echo json_encode($data);
            //TODO return user after recorded in database ==> echo json_encode($stmt);
        } else {
            http_response_code(500);
            echo "Error: " . $conn->error;
        }
    }
    $conn->close();
}

?>