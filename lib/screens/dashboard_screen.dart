import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import 'package:web_admin_bulls_asset/constants/app_constants.dart';
import 'package:web_admin_bulls_asset/theme/app_colors.dart';
import '../providers/user_provider.dart';
import '../providers/course_provider.dart';
import '../widgets/admin_layout.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  Future<void> _loadData() async {
    if (!mounted) return;

    if (mounted) {
      setState(() => _isRefreshing = true);
    }

    try {
      await Future.wait([
        context.read<UserProvider>().fetchUsers(),
        context.read<CourseProvider>().fetchCourses(),
      ]);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load data: $e'),
            backgroundColor: Colors.red,
            action: SnackBarAction(
              label: 'Retry',
              textColor: Colors.white,
              onPressed: _loadData,
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isRefreshing = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final crossAxisCount = MediaQuery.of(context).size.width > 1200 ? 4 : 2;
    final userProvider = context.watch<UserProvider>();
    final courseProvider = context.watch<CourseProvider>();

    return AdminLayout(
      currentRoute: '/',
      child: RefreshIndicator(
        onRefresh: _loadData,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.only(bottom: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Dashboard',
                              style: Theme.of(context).textTheme.displayMedium,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Overview of your academy performance and advisory.',
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    color: AppColors.lightMutedForeground,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Wrap(
                        spacing: 12,
                        runSpacing: 8,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Tooltip(
                            message: 'Refresh dashboard data',
                            child: OutlinedButton.icon(
                              onPressed: _isRefreshing ? null : _loadData,
                              icon: _isRefreshing
                                  ? const SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Icon(Icons.refresh),
                              label: const Text('Refresh'),
                            ),
                          ),
                          Tooltip(
                            message: 'Add new course or content',
                            child: ElevatedButton.icon(
                              onPressed: () =>
                                  Navigator.pushNamed(context, '/content'),
                              icon: const Icon(Icons.add),
                              label: const Text('Add Content'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Stats Cards
            userProvider.isLoading && userProvider.users.isEmpty
                ? _buildLoadingCards(crossAxisCount)
                : GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 1.2,
                    ),
                    itemCount: 4,
                    itemBuilder: (context, index) {
                      return _buildStatCard(
                        index,
                        userProvider,
                        courseProvider,
                      );
                    },
                  ),

            const SizedBox(height: 32),

            // Charts section
            SizedBox(
              height: 400,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Revenue Chart
                  Expanded(flex: 4, child: RevenueChart()),
                  const SizedBox(width: 16),
                  // Recent Sales
                  Expanded(flex: 3, child: RecentSalesCard()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingCards(int crossAxisCount) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.2,
      ),
      itemCount: 4,
      itemBuilder: (context, index) => Card(
        child: Center(
          child: CircularProgressIndicator(color: AppColors.sidebarPrimary),
        ),
      ),
    );
  }

  Widget _buildStatCard(
    int index,
    UserProvider userProvider,
    CourseProvider courseProvider,
  ) {
    final stats = [
      {
        'label': 'Total Students',
        'value': '${userProvider.totalUsers}',
        'change': '+${userProvider.newUsersCount} this month',
        'trend': 'up',
        'icon': Icons.people,
        'onTap': () => Navigator.pushNamed(context, '/students'),
      },
      {
        'label': 'Active Students',
        'value': '${userProvider.activeUsers}',
        'change':
            '${((userProvider.activeUsers / (userProvider.totalUsers > 0 ? userProvider.totalUsers : 1)) * 100).toStringAsFixed(1)}% active',
        'trend': 'up',
        'icon': Icons.person_outline,
        'onTap': () => Navigator.pushNamed(context, '/students'),
      },
      {
        'label': 'Total Courses',
        'value': '${courseProvider.courses.length}',
        'change': 'Manage courses',
        'trend': 'neutral',
        'icon': Icons.book,
        'onTap': () => Navigator.pushNamed(context, '/content'),
      },
      {
        'label': 'Quick Actions',
        'value': 'Manage',
        'change': 'View all sections',
        'trend': 'neutral',
        'icon': Icons.dashboard,
        'onTap': () {},
      },
    ];

    final stat = stats[index];
    final isPositive = stat['trend'] == 'up';

    return Card(
      elevation: 2,
      child: InkWell(
        onTap: stat['onTap'] as VoidCallback?,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    stat['label'] as String,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: AppColors.lightMutedForeground,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.sidebarPrimary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      stat['icon'] as IconData,
                      color: AppColors.sidebarPrimary,
                      size: 20,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    stat['value'] as String,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      if (isPositive)
                        Icon(
                          Icons.arrow_upward,
                          size: 14,
                          color: AppColors.statusSuccess,
                        ),
                      if (isPositive) const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          stat['change'] as String,
                          style: TextStyle(
                            color: isPositive
                                ? AppColors.statusSuccess
                                : AppColors.lightMutedForeground,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class StatCard extends StatelessWidget {
  final DashboardStat stat;
  final bool isPositive;

  const StatCard({Key? key, required this.stat, required this.isPositive})
    : super(key: key);

  IconData _getIcon(String iconName) {
    switch (iconName) {
      case 'users':
        return Icons.people;
      case 'rupee':
        return Icons.currency_rupee;
      case 'book':
        return Icons.book;
      case 'trending':
        return Icons.trending_up;
      default:
        return Icons.dashboard;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  stat.label,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: AppColors.lightMutedForeground,
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: stat.icon == 'rupee'
                        ? AppColors.primaryGreen.withOpacity(0.1)
                        : AppColors.lightMuted,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    _getIcon(stat.icon),
                    size: 18,
                    color: stat.icon == 'rupee'
                        ? AppColors.primaryGreen
                        : AppColors.lightMutedForeground,
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  stat.value,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      isPositive ? Icons.arrow_upward : Icons.arrow_downward,
                      size: 14,
                      color: isPositive
                          ? AppColors.statusSuccess
                          : AppColors.statusError,
                    ),
                    SizedBox(width: 4),
                    Text(
                      stat.change,
                      style: TextStyle(
                        color: isPositive
                            ? AppColors.statusSuccess
                            : AppColors.statusError,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                    SizedBox(width: 4),
                    Text(
                      'from last month',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.lightMutedForeground.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class RevenueChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Revenue Overview',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 20),
            SizedBox(
              height: 300,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: 1000,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: AppColors.lightBorder,
                        strokeWidth: 1,
                      );
                    },
                  ),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          const labels = [
                            'Jan',
                            'Feb',
                            'Mar',
                            'Apr',
                            'May',
                            'Jun',
                            'Jul',
                          ];
                          if (value < labels.length) {
                            return Text(
                              labels[value.toInt()],
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.lightMutedForeground,
                              ),
                            );
                          }
                          return SizedBox();
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            '₹${(value / 1000).toInt()}k',
                            style: TextStyle(
                              fontSize: 10,
                              color: AppColors.lightMutedForeground,
                            ),
                          );
                        },
                        reservedSize: 40,
                      ),
                    ),
                  ),
                  lineBarsData: [
                    LineChartBarData(
                      spots: [
                        FlSpot(0, 1500),
                        FlSpot(1, 2300),
                        FlSpot(2, 3400),
                        FlSpot(3, 2900),
                        FlSpot(4, 4500),
                        FlSpot(5, 5200),
                        FlSpot(6, 4800),
                      ],
                      isCurved: true,
                      color: AppColors.primaryGreen,
                      barWidth: 2,
                      dotData: FlDotData(show: false),
                      belowBarData: BarAreaData(
                        show: true,
                        color: AppColors.primaryGreen.withOpacity(0.1),
                      ),
                    ),
                  ],
                  borderData: FlBorderData(show: false),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RecentSalesCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final sales = [
      {
        'name': 'John Smith',
        'course': 'Technical Analysis Course',
        'amount': '+₹4,999',
      },
      {
        'name': 'Sarah Johnson',
        'course': 'Options Trading Strategy',
        'amount': '+₹7,999',
      },
      {
        'name': 'Mike Brown',
        'course': 'Fundamental Analysis',
        'amount': '+₹2,499',
      },
      {
        'name': 'Emma Wilson',
        'course': 'Technical Analysis Course',
        'amount': '+₹4,999',
      },
      {
        'name': 'David Lee',
        'course': 'Options Trading Strategy',
        'amount': '+₹7,999',
      },
    ];

    return Card(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Recent Sales',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                SizedBox(height: 4),
                Text(
                  'You made 265 sales this month.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.lightMutedForeground,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: sales.length,
                itemBuilder: (context, index) {
                  final sale = sales[index];
                  final initials = sale['name']!
                      .split(' ')
                      .map((e) => e[0])
                      .join();

                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      children: [
                        Container(
                          height: 36,
                          width: 36,
                          decoration: BoxDecoration(
                            color: AppColors.primaryGreen.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: AppColors.primaryGreen.withOpacity(0.2),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              initials,
                              style: TextStyle(
                                color: AppColors.primaryGreen,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                sale['name']!,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                sale['course']!,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: AppColors.lightMutedForeground,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          sale['amount']!,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryGreen,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
