class Product {
  final String id; // Unique identifier
  final String name; // Name of the product
  final String description; // Description of the product
  final double price; // Price of the product
  final int stock; // Number of items in stock
  final List<String> imageUrls; // List of image URLs for the product
  final String? category; // Optional category field
  final double? discount; // Optional discount field
  final String? brand; // Optional brand field

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.stock,
    required this.imageUrls,
    this.category,
    this.discount,
    this.brand,
  });

  // Computed property to check if the product is in stock
  bool get isInStock => stock > 0;

  // Method to dynamically add an image
  void addImage(String url) {
    imageUrls.add(url);
  }

  // Method to dynamically remove an image
  void removeImage(String url) {
    imageUrls.remove(url);
  }
}

// class Product {
//   final String id;
//   final String name;
//   final String description;
//   final double price;
//   final int stock;
//   final List<String> imageUrls;

//   Product({
//     required this.id,
//     required this.name,
//     required this.description,
//     required this.price,
//     required this.stock,
//     required this.imageUrls,
//     // this.imageUrl = '',
//   });

//   bool get isInStock => stock > 0;
// }

