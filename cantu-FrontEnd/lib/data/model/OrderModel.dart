class Order {
  int id;
  String totalAmount;
  String status;
  String createdAt;
  String? address;
  List<OrderItem> items;

  Order({
    required this.id,
    required this.totalAmount,
    required this.status,
    required this.createdAt,
    required this.items,
    required this.address
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    var list = json['items'] as List;
    List<OrderItem> itemsList = list.map((i) => OrderItem.fromJson(i)).toList();

    return Order(
      id: json['id'],
      totalAmount: json['total_amount'],
      status: json['status'],
      createdAt: json['created_at'],
      address: json['address'],
      items: itemsList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'total_amount': totalAmount,
      'status': status,
      'created_at': createdAt,
      'items': items.map((item) => item.toJson()).toList(),
    };
  }
}

class OrderItem {
  int productId;
  int quantity;
  String price;
  String name;
  String description;
  String productPrice;
  String pic;

  OrderItem({
    required this.productId,
    required this.quantity,
    required this.price,
    required this.name,
    required this.description,
    required this.productPrice,
    required this.pic
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      productId: json['product_id'],
      quantity: json['quantity'],
      price: json['price'],
      name: json['name'],
      description: json['description'],
      productPrice: json['product_price'],
      pic: json['pic']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'quantity': quantity,
      'price': price,
      'name': name,
      'description': description,
      'product_price': productPrice,
    };
  }
}
