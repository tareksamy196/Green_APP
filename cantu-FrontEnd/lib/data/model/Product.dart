class Product {
  final int id;
  final String name;
  final String? description;
  final int categoryId;
  final int brandId;
  final String price;
  final int quantity;
  final String imageUrl;
  final String? categoryName;
  final String? brandName;
  final String? categoryImgUrl;

  Product({
    required this.id,
    required this.name,
    required this.categoryId,
    required this.brandId,
    required this.price,
    required this.quantity,
    required this.imageUrl,
    required this.categoryName,
    required this.brandName,
    required this.categoryImgUrl,
    required this.description
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      categoryId: json['category_id'],
      brandId: json['brand_id'],
      price: json['price'],
      quantity: json['quantity'],
      imageUrl: json['pic'],
      categoryName: json['category_name'],
      brandName: json['brand_name'],
      categoryImgUrl: json['category_pic']
    );
  }
}