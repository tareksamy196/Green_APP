<?php
include "../connect.php"; // Include connection details

// Function to filter user input (prevents SQL injection)
function filterRequest($input) {
  return filter_input(INPUT_POST, $input, FILTER_SANITIZE_STRING);
}

if ($_SERVER["REQUEST_METHOD"] == "POST") {
  $userId = filterRequest("user_id");

  if ($userId === null) {
    http_response_code(400);
    echo json_encode(array('error' => 'User ID is required.'));
    exit;
  }

  try {
    // Start database transaction
    $con->begin_transaction();

    // Check if the user has items in the cart
    $stmt = $con->prepare("
      SELECT 
          c.id AS cart_id, 
          c.discount, 
          c.price, 
          chp.product_idproduct AS product_id,
          p.name AS product_name, 
          p.description AS product_description, 
          chp.quantity
      FROM cart c
      JOIN cart_has_product chp ON c.id = chp.cart_idcart
      JOIN product p ON chp.product_idproduct = p.id
      JOIN users_has_cart uhc ON c.id = uhc.cart_idcart
      WHERE uhc.users_idusers = ?
    ");
    $stmt->bind_param("i", $userId);
    $stmt->execute();
    $cartItems = $stmt->get_result();

    if ($cartItems->num_rows > 0) {
      // Calculate the total price
      $total_price = 0;
      while ($item = $cartItems->fetch_assoc()) {
        $total_price += $item['price'] * $item['quantity'];
      }

      // Create a new order
      $stmt = $con->prepare("INSERT INTO Orders (userID, TotalAmount) VALUES (?, ?)");
      $stmt->bind_param("id", $userId, $total_price);
      $stmt->execute();

      if ($stmt->affected_rows === 1) {
        $orderId = $stmt->insert_id;

        // Insert order items
        $stmt = $con->prepare("INSERT INTO OrderProducts (orderID, productID, quantity) VALUES (?, ?, ?)");
        foreach ($cartItems as $item) {
          $stmt->bind_param("iii", $orderId, $item['product_id'], $item['quantity']);
          $stmt->execute();
        }

        // Clear the cart for the user
        $stmt = $con->prepare("
          DELETE c, chp, uhc
          FROM cart c
          LEFT JOIN cart_has_product chp ON c.id = chp.cart_idcart
          LEFT JOIN users_has_cart uhc ON c.id = uhc.cart_idcart
          WHERE uhc.users_idusers = ?
        ");
        $stmt->bind_param("i", $userId);
        $stmt->execute();

        // Commit the transaction if all successful
        $con->commit();
        http_response_code(200);
        echo json_encode(array('success' => 'Order placed successfully!'));
      } else {
        throw new Exception("Failed to create order.");
      }
    } else {
      http_response_code(400);
      echo json_encode(array('error' => 'No items in cart.'));
    }
  } catch (Exception $e) {
    $con->rollback();
    http_response_code(500);
    echo json_encode(array('error' => 'Database error: ' . $e->getMessage()));
  } finally {
    // Close statements and connection
    if (isset($stmt)) {
      $stmt->close();
    }
    $con->close();
  }
}
?>
