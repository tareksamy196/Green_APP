class Request {
  final int id;
  final int userId;
  final int categoryId;
  final int brandId;
  final String name;
  final String price;
  final int quantity;
  final String? description;
  final String pic;
  late final String status;
  final int? reviewedBy;
  final String categoryName;
  final String brandName;
  final String userName;

  Request({
    required this.id,
    required this.userId,
    required this.categoryId,
    required this.brandId,
    required this.name,
    required this.price,
    required this.quantity,
    required this.description,
    required this.pic,
    required this.status,
    this.reviewedBy,
    required this.categoryName,
    required this.brandName,
    required this.userName,
  });

  factory Request.fromJson(Map<String, dynamic> json) {
    return Request(
      id: json['id'],
      userId: json['user_id'],
      categoryId: json['category_id'],
      brandId: json['brand_id'],
      name: json['name'],
      price: json['price'],
      quantity: json['quantity'],
      description: json['description'],
      pic: json['pic'],
      status: json['status'],
      reviewedBy: json['reviewed_by'],
      categoryName: json['category_name'],
      brandName: json['brand_name'],
      userName: json['user_name'],
    );
  }
}
