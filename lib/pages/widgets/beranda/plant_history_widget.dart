import 'package:flutter/material.dart';

class SummaryItemWidget extends StatelessWidget {
  final String title;
  final String amount;
  final IconData icon;
  final bool isConsumption;

  const SummaryItemWidget(
    this.title,
    this.amount,
    this.icon, {
    super.key,
    this.isConsumption = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isConsumption
                ? Colors.blue.withValues(alpha: 0.2)
                : Colors.green.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: isConsumption ? Colors.blue : Colors.green,
            size: 16,
          ),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.black54,
              ),
            ),
            Text(
              amount,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isConsumption ? Colors.blue : Colors.green,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class TransactionItemWidget extends StatelessWidget {
  final Map<String, dynamic> activity;

  const TransactionItemWidget({
    super.key,
    required this.activity,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: activity['color'].withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              activity['icon'],
              color: activity['color'],
              size: 20,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity['title'],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  activity['date'],
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              activity['category'],
              style: TextStyle(
                color: Colors.grey[800],
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(width: 15),
          Text(
            activity['category'] == 'Panen'
                ? "${activity['amount'].toStringAsFixed(1)} kg"
                : activity['category'] == 'Nutrisi'
                    ? "${activity['amount'].toStringAsFixed(1)} L"
                    : "pH ${activity['amount'].toStringAsFixed(1)}",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: activity['isExpense'] ? Colors.blue : Colors.green,
            ),
          ),
        ],
      ),
    );
  }
}
