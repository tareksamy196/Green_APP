<?php


define("MB", 1048576);

// Database connection assumed to be initialized earlier
// For example: $con = new PDO("mysql:host=localhost;dbname=your_db_name", 'username', 'password');

function filterRequest($requestname)
{
    return isset($_POST[$requestname]) ? htmlspecialchars(strip_tags($_POST[$requestname])) : null;
}

function getAllData($table, $where = null, $values = [])
{
    global $con;
    $query = "SELECT * FROM $table" . ($where ? " WHERE $where" : '');
    $stmt = $con->prepare($query);
    $stmt->execute($values);
    $data = $stmt->fetchAll(PDO::FETCH_ASSOC);
    $count = $stmt->rowCount();
    
    if ($count > 0) {
        echo json_encode(["status" => "success", "data" => $data]);
    } else {
        echo json_encode(["status" => "failure"]);
    }
    return $count;
}

function insertData($table, $data, $json = true)
{
    global $con;
    $fields = implode(',', array_keys($data));
    $placeholders = ':' . implode(', :', array_keys($data));
    $sql = "INSERT INTO $table ($fields) VALUES ($placeholders)";
    
    try {
        $stmt = $con->prepare($sql);
        foreach ($data as $key => $value) {
            $stmt->bindValue(":$key", $value);
        }
        $stmt->execute();
        $count = $stmt->rowCount();
        if ($json) {
            echo json_encode(["status" => $count > 0 ? "success" : "failure"]);
        }
        return $count;
    } catch (PDOException $e) {
        // Optionally, log $e->getMessage() to a file or error log for debugging
        if ($json) {
            echo json_encode(["status" => "failure", "message" => "Database error occurred"]);
        }
        return 0; // Indicate failure
    }
}


function updateData($table, $data, $where, $json = true)
{
    global $con;
    $setParts = [];
    foreach ($data as $key => $value) {
        $setParts[] = "$key = :$key";
    }
    $setString = implode(', ', $setParts);
    $sql = "UPDATE $table SET $setString WHERE $where";
    
    $stmt = $con->prepare($sql);
    foreach ($data as $key => &$value) {
        $stmt->bindParam(":$key", $value);
    }
    $stmt->execute();
    $count = $stmt->rowCount();
    if ($json) {
        echo json_encode(["status" => $count > 0 ? "success" : "failure"]);
    }
    return $count;
}

function deleteData($table, $where, $json = true)
{
    global $con;
    $sql = "DELETE FROM $table WHERE $where";
    $stmt = $con->prepare($sql);
    $stmt->execute();
    $count = $stmt->rowCount();
    if ($json) {
        echo json_encode(["status" => $count > 0 ? "success" : "failure"]);
    }
    return $count;
}

function imageUpload($imageRequest)
{
    global $msgError;
    $imagename = rand(1000, 10000) . $_FILES[$imageRequest]['name'];
    $imagetmp = $_FILES[$imageRequest]['tmp_name'];
    $imagesize = $_FILES[$imageRequest]['size'];
    $allowExt = ["jpg", "png", "gif", "jpeg", "pdf"];
    $ext = strtolower(pathinfo($imagename, PATHINFO_EXTENSION));
    
    if (!in_array($ext, $allowExt)) {
        $msgError = "EXT";
    }
    if ($imagesize > 2 * MB) {
        $msgError = "size";
    }
    if (empty($msgError)) {
        move_uploaded_file($imagetmp, "../upload/" . $imagename);
        return $imagename;
    } else {
        return false;
    }
}

function deleteFile($dir, $imagename)
{
    $filePath = $dir . "/" . $imagename;
    if (file_exists($filePath)) {
        unlink($filePath);
    }
}

function checkAuthenticate()
{
    if (!isset($_SERVER['PHP_AUTH_USER']) || $_SERVER['PHP_AUTH_USER'] != "wael" || $_SERVER['PHP_AUTH_PW'] != "wael12345") {
        header('WWW-Authenticate: Basic realm="My Realm"');
        header('HTTP/1.0 401 Unauthorized');
        echo 'Page Not Found';
        exit;
    }
}

function printFailure($message = "An error occurred")
{
    echo json_encode(["status" => "failure", "message" => $message]);
}
function sendEmail($to , $title , $body){
    $header = "From: support@waelabohamza.com " . "\n" . "CC: waeleagle1243@gmail.com" ; 
    //mail($to , $title , $body , $header) ; 
    echo "Success" ; 
    }

// Ensure to call `checkAuthenticate()` where authentication is needed.
// Example usage of the functions can be tailored to your specific requirements.

?>
