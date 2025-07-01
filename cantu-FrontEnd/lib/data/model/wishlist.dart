class WishlistItem {
  final int productId;
  final String name;
  final String description;
  final String price;
  final String pic;

  WishlistItem({
    required this.productId,
    required this.name,
    required this.description,
    required this.price,
    required this.pic,
  });

  factory WishlistItem.fromJson(Map<String, dynamic> json) {
    return WishlistItem(
      productId: json['product_id'],
      name: json['name'],
      description: json['description'],
      price: json['price'],
      pic: json['pic'],
    );
  }
}
