import 'package:flutter/material.dart';
// import 'package:carousel_slider/carousel_slider.dart' as carousel_slider;
// import 'package:carousel_slider/carousel_controller.dart' as carousel_slider_controller;
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../models/cart_item.dart';
import '../providers/cart_provider.dart';
import 'request_cart_page.dart';

class ProductPage extends StatefulWidget {
  final Product product;

  const ProductPage({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  int quantity = 0; // quantity state
  int currentImageIndex = 0; // current image index state
  bool isHovering = false; // state to track hover over image 

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

  void openMagnifier(BuildContext context) {
    final PageController pageController =
        PageController(initialPage: currentImageIndex);

    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setState) {
          return Dialog(
            backgroundColor: Colors.black,
            child: Stack(
              children: [
                PhotoViewGallery.builder(
                  itemCount: widget.product.imageUrls.length,
                  pageController: pageController, 
                  builder: (context, index) {
                    return PhotoViewGalleryPageOptions(
                      imageProvider: NetworkImage(widget.product.imageUrls[index]),
                      initialScale: PhotoViewComputedScale.contained,
                      heroAttributes: PhotoViewHeroAttributes(
                          tag: widget.product.imageUrls[index]),
                    );
                  },
                  onPageChanged: (index) {
                    setState(() {
                      currentImageIndex = index;
                    });
                  },
                ),
                if (currentImageIndex > 0) // only show if not 1st image
                  Positioned(
                    left: 10,
                    top: MediaQuery.of(context).size.height * 0.4,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 30),
                      onPressed: () {
                        if (currentImageIndex > 0) {
                          pageController.previousPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                          setState(() {
                            currentImageIndex--;
                          });
                        }
                      },
                    ),
                  ),
                if (currentImageIndex < widget.product.imageUrls.length - 1)
                  Positioned(
                    right: 10,
                    top: MediaQuery.of(context).size.height * 0.4,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 30),
                      onPressed: () {
                        if (currentImageIndex < widget.product.imageUrls.length - 1) {
                          pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                          setState(() {
                            currentImageIndex++;
                          });
                        }
                      },
                    ),
                  ),
                Positioned(
                  top: 20,
                  right: 20,
                  child: IconButton(
                    icon: const Icon(Icons.close, color: Colors.white, size: 30),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void addToCart(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);

    cartProvider.addItem(CartItem(product: widget.product, quantity: quantity));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$quantity x ${widget.product.name} added to the cart!')),
    );

    setState(() {
      quantity = 0; 
    });
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Selected Product', style: TextStyle(color: Colors.white)),
        actions: [
          Stack(
            alignment: Alignment.topRight,
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart, color: Colors.white),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RequestCartPage()),
                  );
                },
              ),
              if (cartProvider.totalQuantity > 0)
                Positioned(
                  right: 2,
                  top: 2,
                  child: Container(
                    padding: const EdgeInsets.all(4.0),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${cartProvider.totalQuantity}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
        backgroundColor: const Color(0xFF002856),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // image carousel (hover shows tap to zoom, left/right arrows)
            Expanded(
              flex: 5,
              child: Stack(
                children: [
                  MouseRegion(
                    onEnter: (_) {
                      setState(() {
                        isHovering = true;
                      });
                    },
                    onExit: (_) {
                      setState(() {
                        isHovering = false;
                      });
                    },
                    child: GestureDetector(
                      onTap: () => openMagnifier(context),
                      child: Stack(
                        children: [
                          Image.network(
                            widget.product.imageUrls[currentImageIndex],
                            fit: BoxFit.contain,
                            width: double.infinity,
                          ),
                          if (isHovering)
                            Positioned.fill(
                              child: Container(
                                color: Colors.black.withOpacity(0.5),
                                child: const Center(
                                  child: Text(
                                    'Tap to Zoom',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 10,
                    top: 0,
                    bottom: 0,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_ios),
                      color: Colors.white,
                      onPressed: navigateToPreviousImage,
                    ),
                  ),
                  Positioned(
                    right: 10,
                    top: 0,
                    bottom: 0,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_forward_ios),
                      color: Colors.white,
                      onPressed: navigateToNextImage,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: widget.product.imageUrls.asMap().entries.map((entry) {
                int index = entry.key;
                return Container(
                  width: 8.0,
                  height: 8.0,
                  margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 4.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: currentImageIndex == index ? Colors.blue : Colors.grey,
                  ),
                );
              }).toList(),
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
                      onPressed: quantity > 0 ? () => addToCart(context) : null,
                      child: const Text('Add to Cart'),
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

