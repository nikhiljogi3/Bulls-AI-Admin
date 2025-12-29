import 'package:flutter/material.dart';
import 'package:web_admin_bulls_asset/theme/app_colors.dart';
import 'package:web_admin_bulls_asset/widgets/admin_layout.dart';

class ContentScreen extends StatelessWidget {
  const ContentScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final courses = [
      {
        'id': 1,
        'title': 'Technical Analysis Masterclass',
        'videos': 24,
        'students': 150,
        'price': '₹4,999',
      },
      {
        'id': 2,
        'title': 'Options Trading Strategy',
        'videos': 18,
        'students': 85,
        'price': '₹7,999',
      },
      {
        'id': 3,
        'title': 'Fundamental Analysis Basics',
        'videos': 12,
        'students': 200,
        'price': '₹2,499',
      },
    ];

    return AdminLayout(
      currentRoute: '/content',
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
                    Icon(Icons.book, size: 32, color: AppColors.primaryGreen),
                    SizedBox(width: 12),
                    Text(
                      'Content & Courses',
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  'Manage all courses and educational content.',
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'All Courses',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Manage all published courses.',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: AppColors.lightMutedForeground,
                                ),
                          ),
                        ],
                      ),
                      ElevatedButton.icon(
                        onPressed: () {},
                        icon: Icon(Icons.add),
                        label: Text('Add Course'),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 1.1,
                    ),
                    itemCount: courses.length,
                    itemBuilder: (context, index) {
                      final course = courses[index];
                      return CourseCard(course: course);
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CourseCard extends StatelessWidget {
  final Map<String, dynamic> course;

  const CourseCard({Key? key, required this.course}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 80,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.primaryGreen.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.video_library,
                color: AppColors.primaryGreen,
                size: 32,
              ),
            ),
            SizedBox(height: 12),
            Text(
              course['title'],
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${course['videos']} videos',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.lightMutedForeground,
                      ),
                    ),
                    Text(
                      '${course['students']} students',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.lightMutedForeground,
                      ),
                    ),
                  ],
                ),
                Text(
                  course['price'],
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryGreen,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
