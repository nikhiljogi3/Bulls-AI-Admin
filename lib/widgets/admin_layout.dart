import 'package:flutter/material.dart';
import 'package:web_admin_bulls_asset/constants/app_constants.dart';
import 'package:web_admin_bulls_asset/theme/app_colors.dart';

class AdminLayout extends StatefulWidget {
  final Widget child;
  final String currentRoute;

  const AdminLayout({Key? key, required this.child, required this.currentRoute})
    : super(key: key);

  @override
  State<AdminLayout> createState() => _AdminLayoutState();
}

class _AdminLayoutState extends State<AdminLayout> {
  bool _isSidebarExpanded = true;

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      body: Row(
        children: [
          // Sidebar
          if (!isMobile)
            Container(
              width: _isSidebarExpanded ? 256 : 80,
              color: AppColors.sidebarBackground,
              child: Sidebar(
                isExpanded: _isSidebarExpanded,
                currentRoute: widget.currentRoute,
                onToggle: () {
                  setState(() {
                    _isSidebarExpanded = !_isSidebarExpanded;
                  });
                },
              ),
            ),
          // Main content
          Expanded(
            child: Column(
              children: [
                // Header
                AdminHeader(
                  showMenuButton: isMobile,
                  onMenuPressed: () {
                    // Handle mobile menu
                  },
                ),
                // Content
                Expanded(
                  child: Container(
                    color: AppColors.lightBackground,
                    padding: EdgeInsets.symmetric(
                      horizontal: isMobile ? 16 : 32,
                      vertical: 24,
                    ),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 1400),
                        child: widget.child,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Sidebar extends StatelessWidget {
  final bool isExpanded;
  final String currentRoute;
  final VoidCallback onToggle;

  const Sidebar({
    Key? key,
    required this.isExpanded,
    required this.currentRoute,
    required this.onToggle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Logo section
        Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Container(
                height: 48,
                width: 48,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Image.asset('assets/logo.jpeg', fit: BoxFit.contain),
              ),
              if (isExpanded) ...[
                SizedBox(height: 12),
                Text(
                  'Bullsassets',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Admin Panel',
                  style: TextStyle(
                    color: AppColors.sidebarForeground.withOpacity(0.6),
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ],
          ),
        ),
        Divider(color: AppColors.sidebarAccent, height: 1, thickness: 1),
        // Navigation items
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (isExpanded)
                    Padding(
                      padding: EdgeInsets.only(left: 16, bottom: 12),
                      child: Text(
                        'MAIN MENU',
                        style: TextStyle(
                          color: AppColors.sidebarForeground.withOpacity(0.4),
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ...AppConstants.NAV_ITEMS.map((item) {
                    final isActive = currentRoute == item.route;
                    return SidebarNavItem(
                      item: item,
                      isActive: isActive,
                      isExpanded: isExpanded,
                    );
                  }).toList(),
                ],
              ),
            ),
          ),
        ),
        // Logout button
        Padding(
          padding: const EdgeInsets.all(16),
          child: isExpanded
              ? SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('Sign Out'),
                          content: const Text(
                            'Are you sure you want to sign out of your account?',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(ctx),
                              child: const Text('Cancel'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(ctx);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Successfully signed out'),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                              ),
                              child: const Text('Sign Out'),
                            ),
                          ],
                        ),
                      );
                    },
                    icon: const Icon(Icons.logout, size: 18),
                    label: const Text('Sign Out'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[600],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                )
              : Tooltip(
                  message: 'Sign Out',
                  child: IconButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('Sign Out'),
                          content: const Text(
                            'Are you sure you want to sign out?',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(ctx),
                              child: const Text('Cancel'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(ctx);
                                Navigator.pushNamedAndRemoveUntil(
                                  context,
                                  '/login',
                                  (route) => false,
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                              ),
                              child: const Text('Sign Out'),
                            ),
                          ],
                        ),
                      );
                    },
                    icon: Icon(Icons.logout, color: Colors.red[600], size: 24),
                  ),
                ),
        ),
      ],
    );
  }
}

class SidebarNavItem extends StatelessWidget {
  final NavItem item;
  final bool isActive;
  final bool isExpanded;

  const SidebarNavItem({
    Key? key,
    required this.item,
    required this.isActive,
    required this.isExpanded,
  }) : super(key: key);

  IconData _getIcon(String iconName) {
    switch (iconName) {
      case 'dashboard':
        return Icons.dashboard;
      case 'courses':
        return Icons.school;
      case 'live':
        return Icons.live_tv;
      case 'content':
        return Icons.book;
      case 'advisory':
        return Icons.trending_up;
      case 'students':
        return Icons.people;
      case 'payments':
        return Icons.payment;
      case 'announcements':
        return Icons.notifications;
      case 'settings':
        return Icons.settings;
      default:
        return Icons.dashboard;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: isExpanded ? '' : item.title,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        margin: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          color: isActive ? AppColors.sidebarPrimary : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: AppColors.sidebarPrimary.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: isActive
                ? null
                : () {
                    final route = ModalRoute.of(context)?.settings.name;
                    if (route != item.route) {
                      Navigator.of(context).pushReplacementNamed(item.route);
                    }
                  },
            borderRadius: BorderRadius.circular(8),
            hoverColor: isActive
                ? Colors.transparent
                : AppColors.sidebarAccent.withOpacity(0.5),
            splashColor: isActive
                ? Colors.transparent
                : AppColors.sidebarPrimary.withOpacity(0.3),
            highlightColor: isActive
                ? Colors.transparent
                : AppColors.sidebarPrimary.withOpacity(0.2),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: isExpanded
                  ? Row(
                      children: [
                        Icon(
                          _getIcon(item.icon),
                          color: isActive
                              ? Colors.white
                              : AppColors.sidebarForeground.withOpacity(0.6),
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            item.title,
                            style: TextStyle(
                              color: isActive
                                  ? Colors.white
                                  : AppColors.sidebarForeground.withOpacity(
                                      0.6,
                                    ),
                              fontSize: 14,
                              fontWeight: isActive
                                  ? FontWeight.w600
                                  : FontWeight.w500,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    )
                  : Center(
                      child: Icon(
                        _getIcon(item.icon),
                        color: isActive
                            ? Colors.white
                            : AppColors.sidebarForeground.withOpacity(0.6),
                        size: 20,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

class AdminHeader extends StatelessWidget {
  final bool showMenuButton;
  final VoidCallback onMenuPressed;

  const AdminHeader({
    Key? key,
    required this.showMenuButton,
    required this.onMenuPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      decoration: BoxDecoration(
        color: AppColors.lightCardBackground,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (showMenuButton)
            IconButton(
              onPressed: onMenuPressed,
              icon: const Icon(Icons.menu),
              tooltip: 'Menu',
            ),
          const Spacer(),
          // Right side actions
          Row(
            children: [
              Container(
                width: 300,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: TextField(
                  onChanged: (value) {
                    // Search functionality
                  },
                  decoration: InputDecoration(
                    hintText: 'Search...',
                    prefixIcon: Icon(
                      Icons.search,
                      size: 20,
                      color: Colors.grey[600],
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  style: TextStyle(fontSize: 14),
                ),
              ),
              const SizedBox(width: 16),
              PopupMenuButton<String>(
                tooltip: 'Account menu',
                onSelected: (value) {
                  if (value == 'logout') {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('Confirm Logout'),
                        content: const Text(
                          'Are you sure you want to sign out?',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx),
                            child: const Text('Cancel'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(ctx);
                              Navigator.pushNamedAndRemoveUntil(
                                context,
                                '/login',
                                (route) => false,
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                            ),
                            child: const Text('Logout'),
                          ),
                        ],
                      ),
                    );
                  }
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  const PopupMenuItem<String>(
                    value: 'profile',
                    child: ListTile(
                      leading: Icon(Icons.person_outline),
                      title: Text('Profile'),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                  const PopupMenuDivider(),
                  const PopupMenuItem<String>(
                    value: 'logout',
                    child: ListTile(
                      leading: Icon(Icons.logout, color: Colors.red),
                      title: Text(
                        'Logout',
                        style: TextStyle(color: Colors.red),
                      ),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
