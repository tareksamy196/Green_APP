class Brand {
  final int id;
  final int categoryId;
  final String name;

  Brand({required this.id,required this.categoryId, required this.name});

  factory Brand.fromJson(Map<String, dynamic> json) {
    return Brand(
      id: json['id'],
      categoryId: json['category_id'],
      name: json['name'],
    );
  }
}