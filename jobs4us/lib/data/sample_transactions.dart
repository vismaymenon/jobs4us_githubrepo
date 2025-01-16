import '../models/transaction.dart';

final List<Transaction> sampleTransactions = [
  Transaction(
    date: '2025-01-15',
    productName: 'Mandarin Oranges',
    quantity: 2,
    cost: 23.60,
    voucherPoints: 5,
  ),
  Transaction(
    date: '2025-01-14',
    productName: 'Green Tea',
    quantity: 1,
    cost: 5.80,
    voucherPoints: 2,
  ),
  Transaction(
    date: '2025-01-13',
    productName: 'Rice Pack',
    quantity: 3,
    cost: 12.00,
    voucherPoints: 4,
  ),
];
