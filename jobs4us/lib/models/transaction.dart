class Transaction {
  final String date; // date
  final String productName; // product name
  final int quantity; // product quantity
  final double cost; // total cost
  final int voucherPoints; // voucher points used

  Transaction({
    required this.date,
    required this.productName,
    required this.quantity,
    required this.cost,
    required this.voucherPoints,
  });
}
