import 'package:flutter/material.dart';
import '../models/transaction.dart';
import 'resident_profile_page.dart'; 

class TransactionHistoryPage extends StatelessWidget {
  final List<Transaction> transactions;

  const TransactionHistoryPage({
    Key? key,
    required this.transactions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back), // back arrow icon
          onPressed: () {
            // go to Resident Profile Page
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ResidentProfilePage(),
              ),
            );
          },
        ),
        title: const Text(
          'Transaction History',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF002856),
      ),
      body: transactions.isEmpty
          ? const Center(
              child: Text(
                'No transactions yet',
                style: TextStyle(fontSize: 18),
              ),
            )
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    children: const [
                      Expanded(
                        flex: 2,
                        child: Text(
                          'Date',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text(
                          'Product',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          'Qty',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          'Cost',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          'Voucher Points',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: transactions.length,
                    itemBuilder: (context, index) {
                      final transaction = transactions[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        child: Material(
                          elevation: 2,
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            padding: const EdgeInsets.all(12.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.white,
                            ),
                            child: Row(
                              children: [
                                Expanded( // date
                                  flex: 2,
                                  child: Text(
                                    transaction.date,
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ),
                                Expanded( // product name
                                  flex: 3,
                                  child: Text(
                                    transaction.productName,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Expanded( // quantity
                                  flex: 1,
                                  child: Text(
                                    '${transaction.quantity}',
                                    textAlign: TextAlign.right,
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ),
                                Expanded( // cost
                                  flex: 2,
                                  child: Text(
                                    '\$${transaction.cost.toStringAsFixed(2)}',
                                    textAlign: TextAlign.right,
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ),
                                Expanded( // voucher points
                                  flex: 2,
                                  child: Text(
                                    '${transaction.voucherPoints} pts',
                                    textAlign: TextAlign.right,
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}

