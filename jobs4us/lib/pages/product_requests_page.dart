import 'package:flutter/material.dart';
import 'package:jobs4us/models/product.dart';
import '../models/product.dart';

class ProductRequestsPage extends StatefulWidget {
  final List<Product> outOfStockProducts;

  ProductRequestsPage({required this.outOfStockProducts});

  @override
  _ProductRequestsPageState createState() => _ProductRequestsPageState();
}

class _ProductRequestsPageState extends State<ProductRequestsPage> {
  void acceptRequest(int index) {
    setState(() {
      widget.outOfStockProducts[index] = Product(
        id: widget.outOfStockProducts[index].id,
        name: widget.outOfStockProducts[index].name,
        description: widget.outOfStockProducts[index].description,
        price: widget.outOfStockProducts[index].price,
        stock: 50, // Default replenished stock
        imageUrls: widget.outOfStockProducts[index].imageUrls,
        category: widget.outOfStockProducts[index].category,
        discount: widget.outOfStockProducts[index].discount,
        brand: widget.outOfStockProducts[index].brand,
      );
      widget.outOfStockProducts.removeAt(index);
    });
  }

  void deleteRequest(int index) {
    setState(() {
      widget.outOfStockProducts.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Requests'),
        backgroundColor: Color(0xFF002856),
        foregroundColor: Colors.white, // Set text color to white
      ),
      body: widget.outOfStockProducts.isEmpty
          ? Center(
              child: Text(
                'No product requests.',
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: widget.outOfStockProducts.length,
              itemBuilder: (context, index) {
                final product = widget.outOfStockProducts[index];
                return Card(
                  elevation: 4,
                  margin: EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    leading: Image.asset(
                      product.imageUrls.first,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                    title: Text(product.name),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () => deleteRequest(index),
                          icon: Icon(Icons.delete, color: Colors.red),
                        ),
                        IconButton(
                          onPressed: () => acceptRequest(index),
                          icon: Icon(Icons.check, color: Colors.green),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}



