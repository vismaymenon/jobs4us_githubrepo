import 'package:flutter/material.dart';
import '../models/transaction.dart';
import 'resident_profile_page.dart'; // Import the Resident Profile Page

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
          icon: const Icon(Icons.arrow_back), // Back arrow icon
          onPressed: () {
            // Navigate to Resident Profile Page
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
          style: TextStyle(color: Colors.white), // Set title to white
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
                // Column Headers
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
                // List of Transactions
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
                                // Date
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    transaction.date,
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ),
                                // Product Name
                                Expanded(
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
                                // Quantity
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    '${transaction.quantity}',
                                    textAlign: TextAlign.right,
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ),
                                // Cost
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    '\$${transaction.cost.toStringAsFixed(2)}',
                                    textAlign: TextAlign.right,
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ),
                                // Voucher Points
                                Expanded(
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


// import 'package:flutter/material.dart';
// import '../models/transaction.dart';

// class TransactionHistoryPage extends StatelessWidget {
//   final List<Transaction> transactions;

//   const TransactionHistoryPage({
//     Key? key,
//     required this.transactions,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'Transaction History',
//           style: TextStyle(color: Colors.white), // Set title to white
//         ),
//         backgroundColor: const Color(0xFF002856),
//       ),
//       body: transactions.isEmpty
//           ? const Center(
//               child: Text(
//                 'No transactions yet',
//                 style: TextStyle(fontSize: 18),
//               ),
//             )
//           : Column(
//               children: [
//                 // Column Headers
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//                   child: Row(
//                     children: const [
//                       Expanded(
//                         flex: 2,
//                         child: Text(
//                           'Date',
//                           style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                       Expanded(
//                         flex: 3,
//                         child: Text(
//                           'Product',
//                           style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                       Expanded(
//                         flex: 1,
//                         child: Text(
//                           'Qty',
//                           textAlign: TextAlign.right,
//                           style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                       Expanded(
//                         flex: 2,
//                         child: Text(
//                           'Cost',
//                           textAlign: TextAlign.right,
//                           style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                       Expanded(
//                         flex: 2,
//                         child: Text(
//                           'Voucher Points',
//                           textAlign: TextAlign.right,
//                           style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 // List of Transactions
//                 Expanded(
//                   child: ListView.builder(
//                     itemCount: transactions.length,
//                     itemBuilder: (context, index) {
//                       final transaction = transactions[index];
//                       return Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//                         child: Material(
//                           elevation: 2, // Lift effect
//                           borderRadius: BorderRadius.circular(12), // Rounded corners
//                           child: Container(
//                             padding: const EdgeInsets.all(12.0),
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(12),
//                               color: Colors.white,
//                             ),
//                             child: Row(
//                               children: [
//                                 // Date
//                                 Expanded(
//                                   flex: 2,
//                                   child: Text(
//                                     transaction.date,
//                                     style: const TextStyle(fontSize: 14),
//                                   ),
//                                 ),
//                                 // Product Name
//                                 Expanded(
//                                   flex: 3,
//                                   child: Text(
//                                     transaction.productName,
//                                     style: const TextStyle(
//                                       fontSize: 14,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                     overflow: TextOverflow.ellipsis,
//                                   ),
//                                 ),
//                                 // Quantity
//                                 Expanded(
//                                   flex: 1,
//                                   child: Text(
//                                     '${transaction.quantity}',
//                                     textAlign: TextAlign.right,
//                                     style: const TextStyle(fontSize: 14),
//                                   ),
//                                 ),
//                                 // Cost
//                                 Expanded(
//                                   flex: 2,
//                                   child: Text(
//                                     '\$${transaction.cost.toStringAsFixed(2)}',
//                                     textAlign: TextAlign.right,
//                                     style: const TextStyle(
//                                       fontSize: 14,
//                                       color: Colors.grey,
//                                     ),
//                                   ),
//                                 ),
//                                 // Voucher Points
//                                 Expanded(
//                                   flex: 2,
//                                   child: Text(
//                                     '${transaction.voucherPoints} pts',
//                                     textAlign: TextAlign.right,
//                                     style: const TextStyle(
//                                       fontSize: 14,
//                                       color: Colors.grey,
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             ),
//     );
//   }
// }
