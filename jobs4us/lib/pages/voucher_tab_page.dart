import 'package:flutter/material.dart';

class VoucherTabPage extends StatefulWidget {
  @override
  _VoucherTabPageState createState() => _VoucherTabPageState();
}

class _VoucherTabPageState extends State<VoucherTabPage> {
  // Sample data for tasks
  List<Map<String, dynamic>> tasks = [
    {"taskNumber": 101, "description": "Task 1 description", "Value": 10},
    {"taskNumber": 102, "description": "Task 2 description", "Value": 20},
    {"taskNumber": 103, "description": "Task 3 description", "Value": 30},
    {"taskNumber": 104, "description": "Task 4 description", "Value": 40},
    {"taskNumber": 105, "description": "Task 5 description", "Value": 50},
    {"taskNumber": 106, "description": "Task 6 description", "Value": 60},
    {"taskNumber": 107, "description": "Task 7 description", "Value": 70},
    {"taskNumber": 108, "description": "Task 8 description", "Value": 80},
    {"taskNumber": 109, "description": "Task 9 description", "Value": 90},
    {"taskNumber": 110, "description": "Task 10 description", "Value": 100},
  ];

  // Sample data for vouchers
  List<Map<String, dynamic>> vouchers = [
    {"voucherNumber": 201, "description": "Voucher 1", "Value": 15},
    {"voucherNumber": 202, "description": "Voucher 2", "Value": 25},
    {"voucherNumber": 203, "description": "Voucher 3", "Value": 35},
    {"voucherNumber": 204, "description": "Voucher 4", "Value": 45},
    {"voucherNumber": 205, "description": "Voucher 5", "Value": 55},
  ];

  int get totalVoucherValue => vouchers.fold(0, (sum, item) => sum + item['Value'] as int);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tasks and Vouchers'),
      ),
      body: Row(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildSection('Vouchers Available', vouchers, isVoucher: true),
                  SizedBox(height: 10),
                  buildSection('Tasks Available', tasks, isVoucher: false),
                ],
              ),
            ),
          ),
          Container(
            width: 120,
            padding: EdgeInsets.all(12.0),
            //color: Colors.grey[200],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total Voucher Value',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  '\$${totalVoucherValue.toString()}',
                  style: TextStyle(fontSize: 18, color: Colors.green),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
    Widget buildSection(String title, List<Map<String, dynamic>> items, {required bool isVoucher}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            title,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(height: 5),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...items.take(5).map((item) => buildCard(item, isVoucher)).toList(),
              SizedBox(width: 8.0),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GridViewPage(
                        title: title,
                        items: items,
                        isVoucher: isVoucher,
                      ),
                    ),
                  );
                },
                child: Container(
                  width: 120,
                  margin: EdgeInsets.symmetric(horizontal: 8.0),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Center(
                    child: Text(
                      'Show More',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }


  Widget buildCard(Map<String, dynamic> item, bool isVoucher) {
    return Container(
      width: 180,
      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.5), blurRadius: 4, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        children: [
          CircleAvatar(
            backgroundColor: Colors.blue,
            radius: 30,
            child: Text(
              item['description'][0].toUpperCase(),
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
          SizedBox(height: 12),
          Text(
            isVoucher
                ? 'Voucher Number: ${item['voucherNumber']}'
                : 'Task Number: ${item['taskNumber']}',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Text('Value: \$${item['Value']}', style: TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}

class GridViewPage extends StatelessWidget {
  final String title;
  final List<Map<String, dynamic>> items;
  final bool isVoucher;

  GridViewPage({required this.title, required this.items, required this.isVoucher});
    @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
          ),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: [
                  BoxShadow(color: Colors.grey.withOpacity(0.5), blurRadius: 4, offset: Offset(0, 4)),
                ],
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.blue,
                    radius: 30,
                    child: Text(
                      item['description'][0].toUpperCase(),
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    isVoucher
                        ? 'Voucher Number: ${item['voucherNumber']}'
                        : 'Task Number: ${item['taskNumber']}',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text('Value: \$${item['Value']}', style: TextStyle(fontSize: 16)),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}