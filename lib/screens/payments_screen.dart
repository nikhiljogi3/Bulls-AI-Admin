import 'package:flutter/material.dart';
import 'package:web_admin_bulls_asset/theme/app_colors.dart';
import 'package:web_admin_bulls_asset/widgets/admin_layout.dart';

class PaymentsScreen extends StatelessWidget {
  const PaymentsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final payments = [
      {
        'id': 1,
        'student': 'Rahul Sharma',
        'course': 'Technical Analysis',
        'amount': '₹4,999',
        'status': 'Completed',
        'date': '2024-12-20',
      },
      {
        'id': 2,
        'student': 'Priya Patel',
        'course': 'Options Trading',
        'amount': '₹7,999',
        'status': 'Completed',
        'date': '2024-12-19',
      },
      {
        'id': 3,
        'student': 'Amit Singh',
        'course': 'Fundamental Analysis',
        'amount': '₹2,499',
        'status': 'Pending',
        'date': '2024-12-21',
      },
      {
        'id': 4,
        'student': 'Sneha Gupta',
        'course': 'Technical Analysis',
        'amount': '₹4,999',
        'status': 'Failed',
        'date': '2024-12-18',
      },
    ];

    return AdminLayout(
      currentRoute: '/payments',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.payment,
                      size: 32,
                      color: AppColors.primaryGreen,
                    ),
                    SizedBox(width: 12),
                    Text(
                      'Payments',
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  'Track and manage all payment transactions.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.lightMutedForeground,
                  ),
                ),
              ],
            ),
          ),
          Card(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Recent Transactions',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  SizedBox(height: 20),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: [
                        DataColumn(label: Text('ID')),
                        DataColumn(label: Text('Student')),
                        DataColumn(label: Text('Course')),
                        DataColumn(label: Text('Amount')),
                        DataColumn(label: Text('Status')),
                        DataColumn(label: Text('Date')),
                        DataColumn(label: Text('Action')),
                      ],
                      rows: payments
                          .map(
                            (payment) => DataRow(
                              cells: [
                                DataCell(Text('#')),
                                DataCell(Text(payment['student'] as String)),
                                DataCell(Text(payment['course'] as String)),
                                DataCell(
                                  Text(
                                    payment['amount'] as String,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.primaryGreen,
                                    ),
                                  ),
                                ),
                                DataCell(
                                  _buildStatusBadge(
                                    payment['status'] as String,
                                  ),
                                ),
                                DataCell(Text(payment['date'] as String)),
                                DataCell(
                                  PopupMenuButton(
                                    itemBuilder: (context) => [
                                      PopupMenuItem(
                                        child: Text('View'),
                                        value: 'view',
                                      ),
                                      PopupMenuItem(
                                        child: Text('Download Receipt'),
                                        value: 'download',
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color bgColor;
    Color textColor;

    switch (status) {
      case 'Completed':
        bgColor = AppColors.statusSuccess.withOpacity(0.1);
        textColor = AppColors.statusSuccess;
        break;
      case 'Pending':
        bgColor = AppColors.statusWarning.withOpacity(0.1);
        textColor = AppColors.statusWarning;
        break;
      case 'Failed':
        bgColor = AppColors.statusError.withOpacity(0.1);
        textColor = AppColors.statusError;
        break;
      default:
        bgColor = AppColors.lightMuted;
        textColor = AppColors.lightMutedForeground;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
