import 'package:flutter/material.dart';
import 'package:web_admin_bulls_asset/theme/app_colors.dart';
import 'package:web_admin_bulls_asset/widgets/admin_layout.dart';

class AnnouncementsScreen extends StatefulWidget {
  const AnnouncementsScreen({Key? key}) : super(key: key);

  @override
  State<AnnouncementsScreen> createState() => _AnnouncementsScreenState();
}

class _AnnouncementsScreenState extends State<AnnouncementsScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  final List<Map<String, dynamic>> announcements = [
    {
      'id': 1,
      'title': 'Market Holiday',
      'message': 'Market will be closed tomorrow on account of...',
      'date': '2 hrs ago',
      'type': 'General',
    },
    {
      'id': 2,
      'title': 'New Course Added',
      'message': 'Check out our new Options Strategy course!',
      'date': '1 day ago',
      'type': 'Marketing',
    },
    {
      'id': 3,
      'title': 'Live Session Reminder',
      'message': 'Live Q&A starts at 4 PM today.',
      'date': '2 days ago',
      'type': 'Urgent',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return AdminLayout(
      currentRoute: '/announcements',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: EdgeInsets.only(bottom: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.notifications,
                      size: 32,
                      color: AppColors.primaryGreen,
                    ),
                    SizedBox(width: 12),
                    Text(
                      'Announcements',
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  'Send push notifications and updates to students.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.lightMutedForeground,
                  ),
                ),
              ],
            ),
          ),
          // Two column layout
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Create announcement form
              Expanded(
                flex: 1,
                child: Card(
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.campaign,
                              size: 20,
                              color: AppColors.primaryGreen,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Create New Announcement',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          ],
                        ),
                        SizedBox(height: 4),
                        Text(
                          'This will be sent as a push notification to all students.',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: AppColors.lightMutedForeground),
                        ),
                        SizedBox(height: 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Title',
                              style: Theme.of(context).textTheme.labelLarge,
                            ),
                            SizedBox(height: 8),
                            TextField(
                              controller: _titleController,
                              decoration: InputDecoration(
                                hintText: 'Enter title (e.g., Market Alert)',
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Message',
                              style: Theme.of(context).textTheme.labelLarge,
                            ),
                            SizedBox(height: 8),
                            TextField(
                              controller: _messageController,
                              maxLines: 4,
                              decoration: InputDecoration(
                                hintText: 'Type your message here...',
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () {},
                            icon: Icon(Icons.send),
                            label: Text('Send Notification'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(width: 16),
              // History
              Expanded(
                flex: 1,
                child: Card(
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'History',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Past announcements sent.',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: AppColors.lightMutedForeground),
                        ),
                        SizedBox(height: 16),
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: announcements.length,
                          itemBuilder: (context, index) {
                            final item = announcements[index];
                            return Padding(
                              padding: EdgeInsets.symmetric(vertical: 8),
                              child: Container(
                                padding: EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: AppColors.lightMuted,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: AppColors.lightBorder,
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                    item['title'],
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 13,
                                                    ),
                                                  ),
                                                  SizedBox(width: 8),
                                                  Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                          horizontal: 6,
                                                          vertical: 2,
                                                        ),
                                                    decoration: BoxDecoration(
                                                      color: AppColors
                                                          .primaryGreen
                                                          .withOpacity(0.1),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            4,
                                                          ),
                                                      border: Border.all(
                                                        color: AppColors
                                                            .primaryGreen
                                                            .withOpacity(0.2),
                                                      ),
                                                    ),
                                                    child: Text(
                                                      item['type'],
                                                      style: TextStyle(
                                                        fontSize: 10,
                                                        color: AppColors
                                                            .primaryGreen,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 4),
                                              Text(
                                                item['message'],
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: AppColors
                                                      .lightMutedForeground,
                                                ),
                                              ),
                                              SizedBox(height: 4),
                                              Text(
                                                item['date'],
                                                style: TextStyle(
                                                  fontSize: 10,
                                                  color: AppColors
                                                      .lightMutedForeground
                                                      .withOpacity(0.6),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () {},
                                          icon: Icon(
                                            Icons.delete,
                                            size: 18,
                                            color: AppColors.statusError,
                                          ),
                                          constraints: BoxConstraints(),
                                          padding: EdgeInsets.zero,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _messageController.dispose();
    super.dispose();
  }
}
