class CartItem {
  final int id;
  final int cartId;
  final int productId;
  final int quantity;
  final String name;
  final String description;
  final String price;
  final String pic;

  CartItem({
    required this.id,
    required this.cartId,
    required this.productId,
    required this.quantity,
    required this.name,
    required this.description,
    required this.price,
    required this.pic,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'],
      cartId: json['cart_id'],
      productId: json['product_id'],
      quantity: json['quantity'],
      name: json['name'],
      description: json['description'],
      price: json['price'],
      pic: json['pic'],
    );
  }
}

class Cart {
  final List<CartItem> cartItems;

  Cart({required this.cartItems});

  factory Cart.fromJson(Map<String, dynamic> json) {
    var list = json['cart_items'] as List;
    List<CartItem> cartItemsList = list.map((i) => CartItem.fromJson(i)).toList();

    return Cart(cartItems: cartItemsList);
  }
}
