import 'package:flutter/material.dart';
import '../models/product.dart';

class InventoryPage extends StatefulWidget {
  final List<Product> products = [
    Product(
      id: '1',
      name: 'Notebook',
      description: 'A high-quality notebook.',
      price: 2.99,
      stock: 50,
      imageUrls: ['assets/icons/notebook.webp'],
    ),
    Product(
      id: '2',
      name: 'Orange Juice',
      description: 'Fresh orange juice.',
      price: 1.99,
      stock: 0,
      imageUrls: ['assets/icons/peelfresh.webp'],
    ),
    Product(
      id: '3',
      name: 'Bodywash',
      description: 'Gentle body wash.',
      price: 4.99,
      stock: 20,
      imageUrls: ['assets/icons/bodywash.webp'],
    ),
  ];

  @override
  _InventoryPageState createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  void adjustStock(int index, int amount) async {
    bool confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirm Change'),
        content: Text(
          'Are you sure you want to ${amount > 0 ? 'add' : 'remove'} stock for ${widget.products[index].name}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Confirm'),
          ),
        ],
      ),
    );

    if (confirm) {
      setState(() {
        int newStock = widget.products[index].stock + amount;
        if (newStock >= 0) {
          widget.products[index] = Product(
            id: widget.products[index].id,
            name: widget.products[index].name,
            description: widget.products[index].description,
            price: widget.products[index].price,
            stock: newStock,
            imageUrls: widget.products[index].imageUrls,
            category: widget.products[index].category,
            discount: widget.products[index].discount,
            brand: widget.products[index].brand,
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inventory'),
        backgroundColor: Color(0xFF002856),
        foregroundColor: Colors.white, // Set text color to white
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: widget.products.length,
        itemBuilder: (context, index) {
          final product = widget.products[index];
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
              subtitle: Text(
                product.stock > 0 ? 'Stock: ${product.stock}' : 'Out of Stock',
                style: TextStyle(
                  color: product.stock > 0 ? Colors.black : Colors.red,
                ),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () => adjustStock(index, -1),
                    icon: Icon(Icons.remove, color: Colors.red),
                  ),
                  IconButton(
                    onPressed: () => adjustStock(index, 1),
                    icon: Icon(Icons.add, color: Colors.green),
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


