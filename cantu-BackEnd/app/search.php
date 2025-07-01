<?php
require '../../accesstoken.php';
require '../../connect.php';

// Function to sanitize user input
function sanitize_input($input) {
    $input = trim($input);
    $input = stripslashes($input);
    $input = htmlspecialchars($input);
    return $input;
}

// Function to search products by category or product name
function search_products($conn, $search_term) {
    $search_term = sanitize_input($search_term);
    $search_term = "%$search_term%";
    $stmt = $conn->prepare("SELECT p.*, c.name as category_name, b.name as brand_name 
                            FROM product p
                            JOIN category c ON p.category_idcategory = c.id
                            JOIN brand b ON p.brand_idbrand = b.id
                            WHERE p.name LIKE ? OR c.name LIKE ?");
    $stmt->bind_param("ss", $search_term, $search_term);
    $stmt->execute();
    $result = $stmt->get_result();
    $products = [];
    while ($row = $result->fetch_assoc()) {
        $products[] = $row;
    }
    return $products;
}



// Handle GET request for user details or product search
if ($_SERVER["REQUEST_METHOD"] == 'GET') {
    $conn = db_connect();
    if (isset($_GET['id'])) {
        $id = sanitize_input($_GET['id']);
        $query = $conn->prepare('SELECT * FROM users WHERE user_id = ?');
        $query->bind_param('i', $id);
        $query->execute();
        $result = $query->get_result();
        if ($result->num_rows > 0) {
            $users = $result->fetch_assoc();
            $email = $users['email'];
            $access_token = create_access_token($conn, $email);
            header('x-auth-token:' . $access_token);
            http_response_code(200);
            echo json_encode($users);
        } else {
            http_response_code(404);
            echo json_encode(['error' => 'Not Found']);
        }
    } elseif (isset($_GET['search'])) {
        $search_term = sanitize_input($_GET['search']);
        $products = search_products($conn, $search_term);
        if (!empty($products)) {
            http_response_code(200);
            echo json_encode($products);
        } else {
            http_response_code(404);
            echo json_encode(['error' => 'No products found.']);
        }
    }
    $conn->close();
}

// Handle POST request for user authentication
if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $conn = db_connect();
    
    $post_data = json_decode($raw_post_data, true);

    $email = $post_data["email"];
    $password = $post_data["password"];

    $user = validate_credentials($conn, $email, $password);
    if ($user) {
        $access_token = create_access_token($conn, $user['email']);
        header('x-auth-token:' . $access_token);
        http_response_code(200);
        echo json_encode(decode_access_token($access_token));
    } else {
        http_response_code(401);
        echo json_encode(['error' => 'Invalid username or password.']);
    }

    $conn->close();
}
?>
