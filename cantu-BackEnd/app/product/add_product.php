<?php
require '../../connect.php';

// Function to sanitize user input
function sanitize_input($input) {
    $input = trim($input);
    $input = stripslashes($input);
    $input = htmlspecialchars($input);
    return $input;
}

// Function to add a new product
function add_product(
    $conn, $name, $description, $picture, $adding_type,$add_id,$category_id,$brand_id,$brand_category_id,$stock_id,$requestadd_id,$requestadd_charity_id) {


    $name = sanitize_input($name);
    $description = sanitize_input($description);
    $picture = sanitize_input($picture);
    $adding_type = sanitize_input($adding_type);
    $add_id = sanitize_input($add_id);
    $category_id = sanitize_input($category_id);
    $brand_id = sanitize_input($brand_id);
    $brand_category_id = sanitize_input($brand_category_id);
    $stock_id = sanitize_input($stock_id);
    $requestadd_id = sanitize_input($requestadd_id);
    $requestadd_charity_id = sanitize_input($requestadd_charity_id);

    $stmt = $conn->prepare("INSERT INTO product 
    (name, description,picture,adding_type,add_idadd,category_idcategory, brand_idbrand,brand_category_idcategory,stock_idstock,requestadd_idrequestadd,requestadd_charity_idcharity) 
    VALUES (?,?,?,?,?,?,?,?,?,?,?)");

    $stmt->bind_param("ssdi", $name, $description,  $picture ,$adding_type, $add_id, $category_id, $brand_id , $brand_category_id , $stock_id, $requestadd_id, $requestadd_charity_id);
    $stmt->execute();
    $stmt->close();
}

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $conn = db_connect();
    $raw_post_data = file_get_contents("php://input");
    $raw_post_data = json_decode($raw_post_data, true);
    
    // Extracting product details from POST data
    $name = $raw_post_data["name"];
    $description = $raw_post_data["description"];
    $picture = $raw_post_data["picture"];
    $adding_type = $raw_post_data["adding_type"];
    $add_id = $raw_post_data["add_idadd"];
    $category_id = $raw_post_data["category_idcategory"];
    $brand_id = $raw_post_data["brand_idbrand"];
    $brand_category_id = $raw_post_data["brand_category_idcategory"];
    $stock_id = $raw_post_data["stock_idstock"];
    $requestadd_id = $raw_post_data["requestadd_idrequestadd"];
    $requestadd_charity_id = $raw_post_data["requestadd_charity_idcharity"];

    // Adding the product to the database
    add_product(  $conn, $name, $description, $picture, $adding_type,$add_id,$category_id,$brand_id,$brand_category_id,$stock_id,$requestadd_id,$requestadd_charity_id);

    http_response_code(200);
    echo json_encode(array('message' => 'Product added successfully.'));
    
    $conn->close();
}
