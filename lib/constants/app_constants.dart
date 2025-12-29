class AppConstants {
  // Navigation items
  static const List<NavItem> NAV_ITEMS = [
    NavItem(title: "Dashboard", route: "/", icon: "dashboard"),
    NavItem(title: "Live Classes", route: "/live-classes", icon: "live"),
    NavItem(title: "Advisory & Tips", route: "/advisory", icon: "advisory"),
    NavItem(title: "Students", route: "/students", icon: "students"),
    NavItem(
      title: "Payments (Coming Soon)",
      route: "/payments",
      icon: "payments",
    ),
  ];

  // Mock dashboard stats
  static const List<DashboardStat> MOCK_STATS = [
    DashboardStat(
      label: "Total Students",
      value: "1,245",
      change: "+12.5%",
      trend: "up",
      icon: "users",
    ),
    DashboardStat(
      label: "Total Revenue",
      value: "₹8,45,000",
      change: "+8.2%",
      trend: "up",
      icon: "rupee",
    ),
    DashboardStat(
      label: "Active Courses",
      value: "12",
      change: "+2",
      trend: "neutral",
      icon: "book",
    ),
    DashboardStat(
      label: "Active Advisory Calls",
      value: "5",
      change: "-1",
      trend: "down",
      icon: "trending",
    ),
  ];

  // Revenue chart data
  static const List<Map<String, dynamic>> REVENUE_DATA = [
    {"month": "Jan", "revenue": 1500},
    {"month": "Feb", "revenue": 2300},
    {"month": "Mar", "revenue": 3400},
    {"month": "Apr", "revenue": 2900},
    {"month": "May", "revenue": 4500},
    {"month": "Jun", "revenue": 5200},
    {"month": "Jul", "revenue": 4800},
  ];

  // App branding
  static const String APP_NAME = "Bullsassets";
  static const String APP_TAGLINE = "Admin Panel";
  static const String LOGO_PATH = "assets/logo.jpeg";
}

class NavItem {
  final String title;
  final String route;
  final String icon;

  const NavItem({required this.title, required this.route, required this.icon});
}

class DashboardStat {
  final String label;
  final String value;
  final String change;
  final String trend;
  final String icon;

  const DashboardStat({
    required this.label,
    required this.value,
    required this.change,
    required this.trend,
    required this.icon,
  });
}
