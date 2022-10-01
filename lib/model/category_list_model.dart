class Category {
  List category = [];

  Category({
    required this.category,
  });

  factory Category.fromMap(map) {
    return Category(
      category: map['category'],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'category': category,
    };
  }
}
