class Product {
  final String id; // unique id
  final String name; // product name
  final String description; // pdt description
  final double price; // price
  final int stock; // inventory level
  final List<String> imageUrls; // list of image URLs for  product
  final String? category; // category (optional)
  final double? discount; // discount (optional)
  final String? brand; // brand (optional)

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

  // check if product is in stock
  bool get isInStock => stock > 0;

  // add an image
  void addImage(String url) {
    imageUrls.add(url);
  }

  // remove an image
  void removeImage(String url) {
    imageUrls.remove(url);
  }
}
