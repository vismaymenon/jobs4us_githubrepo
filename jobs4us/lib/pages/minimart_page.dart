import 'package:flutter/material.dart';
import 'package:jobs4us/data/sample_product.dart';
import 'package:jobs4us/pages/product_page.dart';
import 'package:jobs4us/pages/resident_profile_page.dart';
import 'package:jobs4us/pages/voucher_tab_page.dart';  // Import VoucherTasksPage

class MinimartPage extends StatefulWidget {
  @override
  _MinimartPageState createState() => _MinimartPageState();
}

class _MinimartPageState extends State<MinimartPage> {
  int _selectedTabIndex = 0;

  void _onTabSelected(int index) {
    setState(() {
      _selectedTabIndex = index;
    });
  }

  void _navigateToProductPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductPage(product: sampleProduct, cartItems: []),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Image.asset(
                  'assets/icons/shop_logo.webp',
                  width: 110,
                  height: 110,
                ),
                SizedBox(width: 10),
                GestureDetector(
                  onTap: () => _onTabSelected(0),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 5),
                    decoration: _selectedTabIndex == 0
                        ? BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: Color(0xFFD31B22), width: 3),
                            ),
                          )
                        : null,
                    child: Text(
                      'Minimart',
                      style: TextStyle(
                        color: _selectedTabIndex == 0
                            ? Colors.white
                            : Colors.white70,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                GestureDetector(
                  onTap: () => _onTabSelected(1),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 5),
                    decoration: _selectedTabIndex == 1
                        ? BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: Color(0xFFD31B22), width: 3),
                            ),
                          )
                        : null,
                    child: Text(
                      'Vouchers',
                      style: TextStyle(
                        color: _selectedTabIndex == 1
                            ? Colors.white
                            : Colors.white70,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    // Navigate to the ResidentProfilePage
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ResidentProfilePage()),
                    );
                  },
                  icon: Icon(Icons.account_circle, color: Colors.white),
                ),
              ],
            ),
          ],
        ),
        backgroundColor: Color(0xFF002856),
      ),
      body: _selectedTabIndex == 0
          ? Column(
              children: [
                SizedBox(height: 20),
                Text(
                  'Welcome to MWH Minimart!',
                  style: TextStyle(fontSize: 28),
                ),
                SizedBox(height: 20),
                Expanded(
                  child: GridView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3, 
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16, 
                    ),
                    itemCount: _items.length,
                    itemBuilder: (context, index) {
                      final item = _items[index];
                      return GestureDetector(
                        onTap: () => _navigateToProductPage(context),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              item['image']!,
                              width: 190,
                              height: 190,
                            ),
                            SizedBox(height: 12),
                            Text(
                              item['title']!,
                              style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 8),
                            Text(
                              item['price']!,
                              style: TextStyle(fontSize: 16, color: Color(0xFFD31B22)),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                )
              ],
            )
          : VoucherTabPage(),  // Changed to VoucherTasksPage
    );
  }

  final List<Map<String, String>> _items = [
    {'image': 'assets/icons/notebook.webp', 'title': 'Notebook', 'price': '8 Vouchers'},
    {'image': 'assets/icons/rollercoaster.webp', 'title': 'Roller Coaster Chips', 'price': '5 Vouchers'},
    {'image': 'assets/icons/peelfresh.webp', 'title': 'Orange Juice', 'price': '7 Vouchers'},
    {'image': 'assets/icons/bodywash.webp', 'title': 'Bodywash', 'price': '10 Vouchers'},
    {'image': 'assets/icons/skittles.webp', 'title': 'Skittles', 'price': '15 Vouchers'},
    {'image': 'assets/icons/toycar.webp', 'title': 'Toy Car', 'price': '8 Vouchers'},
  ];
}