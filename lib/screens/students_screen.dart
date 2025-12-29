import 'package:flutter/material.dart';
import 'package:web_admin_bulls_asset/theme/app_colors.dart';
import 'package:web_admin_bulls_asset/widgets/admin_layout.dart';

class StudentsScreen extends StatefulWidget {
  const StudentsScreen({Key? key}) : super(key: key);

  @override
  State<StudentsScreen> createState() => _StudentsScreenState();
}

class _StudentsScreenState extends State<StudentsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final List<Map<String, dynamic>> students = [
    {
      'id': 1,
      'name': 'Rahul Sharma',
      'email': 'rahul@example.com',
      'batch': 'Batch A',
      'status': 'Active',
      'joined': '2024-12-01',
    },
    {
      'id': 2,
      'name': 'Priya Patel',
      'email': 'priya@example.com',
      'batch': 'Batch B',
      'status': 'Active',
      'joined': '2024-12-05',
    },
    {
      'id': 3,
      'name': 'Amit Singh',
      'email': 'amit@example.com',
      'batch': 'Batch A',
      'status': 'Inactive',
      'joined': '2024-11-20',
    },
    {
      'id': 4,
      'name': 'Sneha Gupta',
      'email': 'sneha@example.com',
      'batch': 'Batch C',
      'status': 'Active',
      'joined': '2024-12-10',
    },
    {
      'id': 5,
      'name': 'Vikram Malhotra',
      'email': 'vikram@example.com',
      'batch': 'Batch B',
      'status': 'Pending',
      'joined': '2024-12-15',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filteredStudents = students
        .where(
          (s) =>
              s['name'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
              s['email'].toLowerCase().contains(_searchQuery.toLowerCase()),
        )
        .toList();

    return AdminLayout(
      currentRoute: '/students',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: EdgeInsets.only(bottom: 32),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.people,
                          size: 32,
                          color: AppColors.primaryGreen,
                        ),
                        SizedBox(width: 12),
                        Text(
                          'Students Management',
                          style: Theme.of(context).textTheme.displayMedium,
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Manage enrollments, active students, and batches.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.lightMutedForeground,
                      ),
                    ),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.mail),
                  label: Text('Send Announcement'),
                ),
              ],
            ),
          ),
          // Table Card
          Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'All Students',
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              SizedBox(height: 4),
                              Text(
                                'List of all registered students in the platform.',
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(
                                      color: AppColors.lightMutedForeground,
                                    ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: 250,
                                child: TextField(
                                  controller: _searchController,
                                  onChanged: (value) {
                                    setState(() {
                                      _searchQuery = value;
                                    });
                                  },
                                  decoration: InputDecoration(
                                    hintText: 'Search students...',
                                    prefixIcon: Icon(Icons.search, size: 18),
                                    isDense: true,
                                    contentPadding: EdgeInsets.symmetric(
                                      vertical: 12,
                                      horizontal: 12,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 8),
                              OutlinedButton.icon(
                                onPressed: () {},
                                icon: Icon(Icons.filter_list, size: 18),
                                label: Text(''),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: [
                      DataColumn(label: Text('ID')),
                      DataColumn(label: Text('Student')),
                      DataColumn(label: Text('Email')),
                      DataColumn(label: Text('Batch')),
                      DataColumn(label: Text('Status')),
                      DataColumn(label: Text('Joined Date')),
                      DataColumn(label: Text('Action')),
                    ],
                    rows: filteredStudents
                        .map(
                          (student) => DataRow(
                            cells: [
                              DataCell(
                                Text(
                                  '#${student['id'].toString().padLeft(4, '0')}',
                                ),
                              ),
                              DataCell(Text(student['name'])),
                              DataCell(Text(student['email'])),
                              DataCell(
                                Chip(
                                  label: Text(student['batch']),
                                  backgroundColor: AppColors.primaryGreenLight,
                                  labelStyle: TextStyle(
                                    color: AppColors.primaryGreen,
                                  ),
                                ),
                              ),
                              DataCell(_buildStatusBadge(student['status'])),
                              DataCell(Text(student['joined'])),
                              DataCell(
                                PopupMenuButton(
                                  itemBuilder: (context) => [
                                    PopupMenuItem(
                                      child: Text('View'),
                                      value: 'view',
                                    ),
                                    PopupMenuItem(
                                      child: Text('Edit'),
                                      value: 'edit',
                                    ),
                                    PopupMenuItem(
                                      child: Text('Delete'),
                                      value: 'delete',
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
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color backgroundColor;
    Color textColor;

    switch (status) {
      case 'Active':
        backgroundColor = AppColors.statusSuccess.withOpacity(0.1);
        textColor = AppColors.statusSuccess;
        break;
      case 'Inactive':
        backgroundColor = Colors.grey.withOpacity(0.1);
        textColor = Colors.grey[700]!;
        break;
      case 'Pending':
        backgroundColor = AppColors.statusWarning.withOpacity(0.1);
        textColor = AppColors.statusWarning;
        break;
      default:
        backgroundColor = AppColors.lightMuted;
        textColor = AppColors.lightMutedForeground;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
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

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
