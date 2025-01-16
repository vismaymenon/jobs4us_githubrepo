import 'package:flutter/material.dart';
import 'package:jobs4us/pages/request_cart_page.dart';
// import 'package:carousel_slider/carousel_slider.dart' as carousel_slider;
// import 'package:carousel_slider/carousel_controller.dart' as carousel_slider_controller;
import 'package:photo_view/photo_view.dart';

import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import '../models/product.dart';
import '../models/cart_item.dart';
import 'minimart_page.dart'; // Import Home Page for navigation

class ProductPage extends StatefulWidget {
  final Product product;
  final List<CartItem> cartItems; // Shared cart list

  const ProductPage({
    Key? key,
    required this.product,
    required this.cartItems,
  }) : super(key: key);

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  int quantity = 0; // State for quantity
  int currentImageIndex = 0; // State for current image index
  
  // Calculate total items in the cart
  int get totalCartQuantity {
    return widget.cartItems.fold(0, (total, item) => total + item.quantity);
  }
  
  void incrementQuantity() {
    setState(() {
      quantity++;
    });
  }

  void decrementQuantity() {
    setState(() {
      if (quantity > 0) {
        quantity--;
      }
    });
  }

  void navigateToPreviousImage() {
    setState(() {
      currentImageIndex = (currentImageIndex - 1 + widget.product.imageUrls.length) %
          widget.product.imageUrls.length;
    });
  }

  void navigateToNextImage() {
    setState(() {
      currentImageIndex = (currentImageIndex + 1) % widget.product.imageUrls.length;
    });
  }

  void addToCart() {
    final existingItem = widget.cartItems.firstWhere(
      (item) => item.product.id == widget.product.id,
      orElse: () => CartItem(product: widget.product, quantity: 0),
    );

    if (existingItem.quantity == 0) {
      widget.cartItems.add(CartItem(product: widget.product, quantity: quantity));
    } else {
      setState(() {
        existingItem.quantity += quantity;
      });
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${quantity}x ${widget.product.name} added to the cart!')),
    );

    setState(() {
      quantity = 0; // Reset quantity
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back), // Back arrow
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MinimartPage(), // Navigate to Home Page
              ),
            );
          },
        ),
        title: const Text('Selected Product'),
        actions: [
          Stack(
            alignment: Alignment.topRight, // Align the badge with the top-right corner
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RequestCartPage(cartItems: widget.cartItems),
                    ),
                  );
                },
              ),
              if (totalCartQuantity > 0) // Show the badge only if there are items in the cart
                Positioned(
                  right: 2, // Adjust the right position to align with the icon
                  top: 2, // Adjust the top position for better placement
                  child: Container(
                    padding: const EdgeInsets.all(4.0), // Padding inside the bubble
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '$totalCartQuantity',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10, // Smaller font size for better fit
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ], // Updated title
        backgroundColor: const Color(0xFF002856),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Image Carousel with Arrows
            Expanded(
              flex: 5,
              child: Stack(
                children: [
                  GestureDetector(
                    onTap: () {
                      // Placeholder for magnifier function
                    },
                    child: Image.network(
                      widget.product.imageUrls[currentImageIndex],
                      fit: BoxFit.contain,
                      width: double.infinity,
                    ),
                  ),
                  Positioned(
                    left: 10,
                    top: 0,
                    bottom: 0,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_ios, size: 30),
                      color: Colors.black,
                      onPressed: navigateToPreviousImage,
                    ),
                  ),
                  Positioned(
                    right: 10,
                    top: 0,
                    bottom: 0,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_forward_ios, size: 30),
                      color: Colors.black,
                      onPressed: navigateToNextImage,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              flex: 5,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.product.name,
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text(widget.product.description,
                        style: const TextStyle(fontSize: 16)),
                    const SizedBox(height: 16),
                    Text('Price: \$${widget.product.price.toStringAsFixed(2)}',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text(
                      widget.product.isInStock ? 'In Stock: ${widget.product.stock}' : 'Out of Stock',
                      style: TextStyle(
                        fontSize: 16,
                        color: widget.product.isInStock ? Colors.green : Colors.red,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ElevatedButton(onPressed: decrementQuantity, child: const Text('-')),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text('$quantity',
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                        ),
                        ElevatedButton(onPressed: incrementQuantity, child: const Text('+')),
                      ],
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: quantity > 0 ? addToCart : null,
                      child: Text(widget.product.isInStock ? 'Add to Cart' : 'Preorder'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// prev starts here

// import 'package:flutter/material.dart';
// import 'package:photo_view/photo_view.dart';
// import 'package:photo_view/photo_view_gallery.dart';
// import '../models/product.dart';
// import '../models/cart_item.dart';
// import 'request_cart_page.dart';

// class ProductPage extends StatefulWidget {
//   final Product product;
//   final List<CartItem> cartItems; // Shared cart list

//   const ProductPage({
//     Key? key,
//     required this.product,
//     required this.cartItems,
//   }) : super(key: key);

//   @override
//   _ProductPageState createState() => _ProductPageState();
// }

// class _ProductPageState extends State<ProductPage> {
//   int quantity = 0; // State for quantity
//   int currentImageIndex = 0; // State for current image index
//   int _selectedTabIndex = 0;

//   void _onTabSelected(int index) {
//     setState(() {
//       _selectedTabIndex = index;
//     });
//   }

//   // Calculate total items in the cart
//   int get totalCartQuantity {
//     return widget.cartItems.fold(0, (total, item) => total + item.quantity);
//   }

//   void incrementQuantity() {
//     setState(() {
//       quantity++;
//     });
//   }

//   void decrementQuantity() {
//     setState(() {
//       if (quantity > 0) {
//         quantity--;
//       }
//     });
//   }

//   void navigateToPreviousImage() {
//     setState(() {
//       currentImageIndex = (currentImageIndex - 1 + widget.product.imageUrls.length) %
//           widget.product.imageUrls.length;
//     });
//   }

//   void navigateToNextImage() {
//     setState(() {
//       currentImageIndex = (currentImageIndex + 1) % widget.product.imageUrls.length;
//     });
//   }

//   void openMagnifier() {
//     showDialog(
//       context: context,
//       builder: (_) => StatefulBuilder(
//         builder: (context, setState) {
//           return Dialog(
//             backgroundColor: Colors.black,
//             child: Stack(
//               children: [
//                 PhotoViewGallery.builder(
//                   itemCount: widget.product.imageUrls.length,
//                   builder: (context, index) {
//                     return PhotoViewGalleryPageOptions(
//                       imageProvider: NetworkImage(widget.product.imageUrls[index]),
//                       initialScale: PhotoViewComputedScale.contained,
//                       heroAttributes: PhotoViewHeroAttributes(tag: widget.product.imageUrls[index]),
//                     );
//                   },
//                   pageController: PageController(initialPage: currentImageIndex),
//                   onPageChanged: (index) {
//                     setState(() {
//                       currentImageIndex = index;
//                     });
//                   },
//                 ),
//                 Positioned(
//                   top: 20,
//                   right: 20,
//                   child: IconButton(
//                     icon: const Icon(Icons.close, color: Colors.white, size: 30),
//                     onPressed: () {
//                       Navigator.of(context).pop();
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }

//   void addToCart() {
//     final existingItem = widget.cartItems.firstWhere(
//       (item) => item.product.id == widget.product.id,
//       orElse: () => CartItem(product: widget.product, quantity: 0),
//     );

//     if (existingItem.quantity == 0) {
//       widget.cartItems.add(CartItem(product: widget.product, quantity: quantity));
//     } else {
//       setState(() {
//         existingItem.quantity += quantity;
//       });
//     }

//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('${quantity}x ${widget.product.name} added to the cart!')),
//     );

//     setState(() {
//       quantity = 0; // Reset quantity
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.product.name),
//         actions: [
//           Stack(
//             alignment: Alignment.topRight, // Align the badge with the top-right corner
//             children: [
//               IconButton(
//                 icon: const Icon(Icons.shopping_cart),
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => RequestCartPage(cartItems: widget.cartItems),
//                     ),
//                   );
//                 },
//               ),
//               if (totalCartQuantity > 0) // Show the badge only if there are items in the cart
//                 Positioned(
//                   right: 2, // Adjust the right position to align with the icon
//                   top: 2, // Adjust the top position for better placement
//                   child: Container(
//                     padding: const EdgeInsets.all(4.0), // Padding inside the bubble
//                     decoration: BoxDecoration(
//                       color: Colors.red,
//                       shape: BoxShape.circle,
//                     ),
//                     child: Text(
//                       '$totalCartQuantity',
//                       style: const TextStyle(
//                         color: Colors.white,
//                         fontSize: 10, // Smaller font size for better fit
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 ),
//             ],
//           ),
//         ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             // Image Carousel with Hover and Magnifier
//             Expanded(
//               flex: 5,
//               child: Stack(
//                 children: [
//                   GestureDetector(
//                     onTap: openMagnifier,
//                     child: Image.network(
//                       widget.product.imageUrls[currentImageIndex],
//                       fit: BoxFit.contain,
//                       width: double.infinity,
//                     ),
//                   ),
//                   Positioned(
//                     left: 10,
//                     top: 0,
//                     bottom: 0,
//                     child: IconButton(
//                       icon: const Icon(Icons.arrow_back_ios, size: 30),
//                       color: Colors.black,
//                       onPressed: navigateToPreviousImage,
//                     ),
//                   ),
//                   Positioned(
//                     right: 10,
//                     top: 0,
//                     bottom: 0,
//                     child: IconButton(
//                       icon: const Icon(Icons.arrow_forward_ios, size: 30),
//                       color: Colors.black,
//                       onPressed: navigateToNextImage,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 16),
//             Expanded(
//               flex: 5,
//               child: SingleChildScrollView(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(widget.product.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
//                     const SizedBox(height: 8),
//                     Text(widget.product.description, style: const TextStyle(fontSize: 16)),
//                     const SizedBox(height: 16),
//                     Text('Price: \$${widget.product.price.toStringAsFixed(2)}',
//                         style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//                     const SizedBox(height: 8),
//                     Text(
//                       widget.product.isInStock ? 'In Stock: ${widget.product.stock}' : 'Out of Stock',
//                       style: TextStyle(
//                         fontSize: 16,
//                         color: widget.product.isInStock ? Colors.green : Colors.red,
//                       ),
//                     ),
//                     const SizedBox(height: 24),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       children: [
//                         ElevatedButton(onPressed: decrementQuantity, child: const Text('-')),
//                         Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                           child: Text('$quantity', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//                         ),
//                         ElevatedButton(onPressed: incrementQuantity, child: const Text('+')),
//                       ],
//                     ),
//                     const SizedBox(height: 24),
//                     ElevatedButton(
//                       onPressed: quantity > 0 ? addToCart : null,
//                       child: Text(widget.product.isInStock ? 'Add to Cart' : 'Preorder'),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// prev ends here

// class ProductPage extends StatefulWidget {
//   final String productName;
//   final String description;
//   final double price;
//   final int stock;
//   final List<String> imageUrls;

//   const ProductPage({
//     Key? key,
//     required this.productName,
//     required this.description,
//     required this.price,
//     required this.stock,
//     required this.imageUrls,
//   }) : super(key: key);

//   @override
//   _ProductPageState createState() => _ProductPageState();
// }

// class _ProductPageState extends State<ProductPage> {
//   int quantity = 0; // State for quantity
//   int currentImageIndex = 0; // State for current image index
//   bool isMagnifierActive = false; // State to track magnifier activation

//   void incrementQuantity() {
//     setState(() {
//       if (quantity < widget.stock) {
//         quantity++;
//       }
//     });
//   }

//   void decrementQuantity() {
//     setState(() {
//       if (quantity > 0) {
//         quantity--;
//       }
//     });
//   }

//   void navigateToPreviousImage() {
//     setState(() {
//       currentImageIndex = (currentImageIndex - 1 + widget.imageUrls.length) %
//           widget.imageUrls.length;
//     });
//   }

//   void navigateToNextImage() {
//     setState(() {
//       currentImageIndex = (currentImageIndex + 1) % widget.imageUrls.length;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.productName),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             // Image Carousel with Magnifier
//             Expanded(
//               flex: 5,
//               child: Stack(
//                 children: [
//                   Center(
//                     child: GestureDetector(
//                       onLongPress: () {
//                         // Activate the magnifier
//                         setState(() {
//                           isMagnifierActive = true;
//                         });
//                       },
//                       onLongPressUp: () {
//                         // Deactivate the magnifier
//                         setState(() {
//                           isMagnifierActive = false;
//                         });
//                       },
//                       child: Stack(
//                         children: [
//                           // Main Image
//                           Image.network(
//                             widget.imageUrls[currentImageIndex],
//                             fit: BoxFit.contain,
//                             width: double.infinity,
//                           ),
//                           // Magnifier Overlay
//                           if (isMagnifierActive)
//                             Positioned.fill(
//                               child: GestureDetector(
//                                 onTap: () {
//                                   showDialog(
//                                     context: context,
//                                     builder: (_) => Dialog(
//                                       child: PhotoView(
//                                         imageProvider: NetworkImage(
//                                             widget.imageUrls[currentImageIndex]),
//                                         backgroundDecoration: const BoxDecoration(
//                                           color: Colors.white,
//                                         ),
//                                       ),
//                                     ),
//                                   );
//                                 },
//                                 child: Container(
//                                   color: Colors.black.withOpacity(0.5),
//                                   child: const Center(
//                                     child: Text(
//                                       'Tap to Zoom',
//                                       style: TextStyle(
//                                         color: Colors.white,
//                                         fontSize: 18,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   // Left Arrow Button
//                   Positioned(
//                     left: 10,
//                     top: 0,
//                     bottom: 0,
//                     child: IconButton(
//                       icon: const Icon(Icons.arrow_back_ios, size: 30),
//                       color: Colors.black,
//                       onPressed: navigateToPreviousImage,
//                     ),
//                   ),
//                   // Right Arrow Button
//                   Positioned(
//                     right: 10,
//                     top: 0,
//                     bottom: 0,
//                     child: IconButton(
//                       icon: const Icon(Icons.arrow_forward_ios, size: 30),
//                       color: Colors.black,
//                       onPressed: navigateToNextImage,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 8),
//             // Dot Indicators
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: widget.imageUrls.asMap().entries.map((entry) {
//                 int index = entry.key;
//                 return Container(
//                   width: 8.0,
//                   height: 8.0,
//                   margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 4.0),
//                   decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     color: currentImageIndex == index ? Colors.blue : Colors.grey,
//                   ),
//                 );
//               }).toList(),
//             ),
//             const SizedBox(height: 8),
//             // Thumbnail Previews
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: widget.imageUrls.asMap().entries.map((entry) {
//                 int index = entry.key;
//                 String imageUrl = entry.value;
//                 return GestureDetector(
//                   onTap: () {
//                     setState(() {
//                       currentImageIndex = index;
//                     });
//                   },
//                   child: Container(
//                     margin: const EdgeInsets.symmetric(horizontal: 4.0),
//                     padding: const EdgeInsets.all(4.0),
//                     decoration: BoxDecoration(
//                       border: Border.all(
//                           color: currentImageIndex == index
//                               ? Colors.blue
//                               : Colors.grey),
//                       borderRadius: BorderRadius.circular(8.0),
//                     ),
//                     child: Image.network(
//                       imageUrl,
//                       width: 60,
//                       height: 60,
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                 );
//               }).toList(),
//             ),
//             const SizedBox(height: 16),
//             // Product Details
//             Expanded(
//               flex: 5,
//               child: SingleChildScrollView(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       widget.productName,
//                       style: const TextStyle(
//                         fontSize: 24,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     Text(
//                       widget.description,
//                       style: const TextStyle(fontSize: 16),
//                     ),
//                     const SizedBox(height: 16),
//                     Text(
//                       'Price: \$${widget.price.toStringAsFixed(2)}',
//                       style: const TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     Text(
//                       widget.stock > 0
//                           ? 'In Stock: ${widget.stock}'
//                           : 'Out of Stock',
//                       style: TextStyle(
//                         fontSize: 16,
//                         color: widget.stock > 0 ? Colors.green : Colors.red,
//                       ),
//                     ),
//                     const SizedBox(height: 24),
//                     // Quantity Selector
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       children: [
//                         ElevatedButton(
//                           onPressed: decrementQuantity,
//                           child: const Text('-'),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                           child: Text(
//                             '$quantity',
//                             style: const TextStyle(
//                               fontSize: 18,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
//                         ElevatedButton(
//                           onPressed: incrementQuantity,
//                           child: const Text('+'),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 24),
//                     // Add to Cart Button
//                     ElevatedButton(
//                       onPressed: (widget.stock > 0 && quantity > 0)
//                           ? () {
//                               ScaffoldMessenger.of(context).showSnackBar(
//                                 SnackBar(
//                                   content: Text(
//                                       '${quantity}x ${widget.productName} added to cart!'),
//                                 ),
//                               );
//                             }
//                           : null,
//                       child: const Text('Add to Cart'),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


// import 'package:flutter/material.dart';
// import '../models/product.dart';

// class ProductPage extends StatefulWidget {
//   final Product product;

//   const ProductPage({Key? key, required this.product}) : super(key: key);

//   @override
//   _ProductPageState createState() => _ProductPageState();
// }

// class _ProductPageState extends State<ProductPage> {
//   int quantity = 0;

//   void incrementQuantity() {
//     setState(() {
//       if (quantity < widget.product.stock) {
//         quantity++;
//       }
//     });
//   }

//   void decrementQuantity() {
//     setState(() {
//       if (quantity > 0) {
//         quantity--;
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.product.name),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: SingleChildScrollView(
//           child: Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Product Image on the Left
//               if (widget.product.imageUrl.isNotEmpty)
//                 Flexible(
//                   flex: 1, // Control the width of the image
//                   child: Image.network(
//                     widget.product.imageUrl,
//                     height: 200,
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//               const SizedBox(width: 16), // Spacing between image and info
//               // Product Info on the Right
//               Flexible(
//                 flex: 2, // Control the width of the information
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       widget.product.name,
//                       style: const TextStyle(
//                         fontSize: 24,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     Text(
//                       widget.product.description,
//                       style: const TextStyle(fontSize: 16),
//                     ),
//                     const SizedBox(height: 16),
//                     Text(
//                       'Price: \$${widget.product.price.toStringAsFixed(2)}',
//                       style: const TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     Text(
//                       widget.product.isInStock
//                           ? 'In Stock: ${widget.product.stock}'
//                           : 'Out of Stock',
//                       style: TextStyle(
//                         fontSize: 16,
//                         color: widget.product.isInStock
//                             ? Colors.green
//                             : Colors.red,
//                       ),
//                     ),
//                     const SizedBox(height: 24),
//                     // Quantity Selector
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       children: [
//                         ElevatedButton(
//                           onPressed: decrementQuantity,
//                           child: const Text('-'),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                           child: Text(
//                             '$quantity',
//                             style: const TextStyle(
//                               fontSize: 18,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
//                         ElevatedButton(
//                           onPressed: incrementQuantity,
//                           child: const Text('+'),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 24),
//                     // Action Buttons
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       children: [
//                         ElevatedButton(
//                           onPressed: (widget.product.isInStock && quantity > 0)
//                               ? () {
//                                   ScaffoldMessenger.of(context).showSnackBar(
//                                     SnackBar(
//                                       content: Text(
//                                           '${quantity}x ${widget.product.name} added to cart!'),
//                                     ),
//                                   );
//                                 }
//                               : null, // Disabled if out of stock or quantity is 0
//                           child: const Text('Add to Cart'),
//                         ),
//                         ElevatedButton(
//                           onPressed: (!widget.product.isInStock &&
//                                   quantity > 0)
//                               ? () {
//                                   ScaffoldMessenger.of(context).showSnackBar(
//                                     SnackBar(
//                                       content: Text(
//                                           '${quantity}x ${widget.product.name} preordered!'),
//                                     ),
//                                   );
//                                 }
//                               : null, // Disabled if in stock or quantity is 0
//                           child: const Text('Preorder'),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


// class ProductPage extends StatefulWidget {
//   final Product product;

//   const ProductPage({Key? key, required this.product}) : super(key: key);

//   @override
//   _ProductPageState createState() => _ProductPageState();
// }

// class _ProductPageState extends State<ProductPage> {
//   int quantity = 0; // State variable to track the quantity.

//   void incrementQuantity() {
//     setState(() {
//       if (quantity < widget.product.stock) {
//         quantity++;
//       }
//     });
//   }

//   void decrementQuantity() {
//     setState(() {
//       if (quantity > 0) {
//         quantity--;
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.product.name),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               if (widget.product.imageUrl.isNotEmpty)
//                 Center(
//                   child: Image.network(
//                     widget.product.imageUrl,
//                     height: 200,
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//               const SizedBox(height: 16),
//               Text(
//                 widget.product.name,
//                 style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 8),
//               Text(widget.product.description, style: const TextStyle(fontSize: 16)),
//               const SizedBox(height: 16),
//               Text(
//                 'Price: \$${widget.product.price.toStringAsFixed(2)}',
//                 style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 8),
//               Text(
//                 widget.product.isInStock ? 'In Stock: ${widget.product.stock}' : 'Out of Stock',
//                 style: TextStyle(
//                   fontSize: 16,
//                   color: widget.product.isInStock ? Colors.green : Colors.red,
//                 ),
//               ),
//               const SizedBox(height: 24),
//               // Quantity Selector
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   ElevatedButton(
//                     onPressed: decrementQuantity,
//                     child: const Text('-'),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                     child: Text(
//                       '$quantity',
//                       style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                     ),
//                   ),
//                   ElevatedButton(
//                     onPressed: incrementQuantity,
//                     child: const Text('+'),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 24),
//               // Action Buttons
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   ElevatedButton(
//                     onPressed: (widget.product.isInStock && quantity > 0)
//                         ? () {
//                             ScaffoldMessenger.of(context).showSnackBar(
//                               SnackBar(
//                                 content: Text('${quantity}x ${widget.product.name} added to cart!'),
//                               ),
//                             );
//                           }
//                         : null, // Disabled if out of stock or quantity is 0
//                     child: const Text('Add to Cart'),
//                   ),
//                   ElevatedButton(
//                     onPressed: (!widget.product.isInStock && quantity > 0)
//                         ? () {
//                             ScaffoldMessenger.of(context).showSnackBar(
//                               SnackBar(
//                                 content: Text('${quantity}x ${widget.product.name} preordered!'),
//                               ),
//                             );
//                           }
//                         : null, // Disabled if in stock or quantity is 0
//                     child: const Text('Preorder'),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


// // class ProductPage extends StatelessWidget {
// //   final Product product;

// //   const ProductPage({Key? key, required this.product}) : super(key: key);

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text(product.name),
// //       ),
// //       body: Padding(
// //         padding: const EdgeInsets.all(16.0),
// //         child: SingleChildScrollView(
// //           child: Column(
// //             crossAxisAlignment: CrossAxisAlignment.start,
// //             children: [
// //               if (product.imageUrl.isNotEmpty)
// //                 Center(
// //                   child: Image.network(
// //                     product.imageUrl,
// //                     height: 200,
// //                     fit: BoxFit.cover,
// //                   ),
// //                 ),
// //               const SizedBox(height: 16),
// //               Text(
// //                 product.name,
// //                 style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
// //               ),
// //               const SizedBox(height: 8),
// //               Text(product.description, style: const TextStyle(fontSize: 16)),
// //               const SizedBox(height: 16),
// //               Text(
// //                 'Price: \$${product.price.toStringAsFixed(2)}',
// //                 style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
// //               ),
// //               const SizedBox(height: 8),
// //               Text(
// //                 product.isInStock ? 'In Stock: ${product.stock}' : 'Out of Stock',
// //                 style: TextStyle(
// //                   fontSize: 16,
// //                   color: product.isInStock ? Colors.green : Colors.red,
// //                 ),
// //               ),
// //               const SizedBox(height: 24),
// //               Row(
// //                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
// //                 children: [
// //                   ElevatedButton(
// //                     onPressed: product.isInStock ? () {
// //                       ScaffoldMessenger.of(context).showSnackBar(
// //                         SnackBar(content: Text('${product.name} added to cart!')),
// //                       );
// //                     } : null,
// //                     child: const Text('Add to Cart'),
// //                   ),
// //                   ElevatedButton(
// //                     onPressed: !product.isInStock ? () {
// //                       ScaffoldMessenger.of(context).showSnackBar(
// //                         SnackBar(content: Text('${product.name} preordered!')),
// //                       );
// //                     } : null,
// //                     child: const Text('Preorder'),
// //                   ),
// //                 ],
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }
