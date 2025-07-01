<?php
$servername = "localhost";
$username = "root";
$password = "root@2024";
$database = "cantu";
echo "start";
// Create connection
$conn = mysqli_connect($servername, $username, $password, $database);

// Check connection
if (!$conn) {
    die("Connection failed: " . mysqli_connect_error());
}

try {
    // Create a new PDO instance

    echo "\ntry";
    $name = 'name';
    $categoryId = 1;
    $brandId = 1;
    $price = '300';
    $imageUrl = "asdnasfjasf.com";
    $seller_id = 1;
    
    // Prepare the SQL statement with placeholders
    $sql ="INSERT INTO product (seller_id,name, category_id, brand_id, price, pic) VALUES ('$seller_id','$name','$categoryId','$brandId','$price','$imageUrl')";


    // Prepare the statement
    //$stmt = $conn->prepare($sql);

    echo "\n statment";
  

    

    echo "\n execute";
    // Execute the statement
    $conn->query($sql);
    echo "New record created successfully";
} catch(PDOException $e) {
    echo "Error: " . $e->getMessage();
}

?>

