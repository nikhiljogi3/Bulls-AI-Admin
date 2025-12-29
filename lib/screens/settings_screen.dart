import 'package:flutter/material.dart';
import 'package:web_admin_bulls_asset/theme/app_colors.dart';
import 'package:web_admin_bulls_asset/widgets/admin_layout.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AdminLayout(
      currentRoute: '/settings',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.settings,
                      size: 32,
                      color: AppColors.primaryGreen,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Settings',
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Manage application settings and preferences.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.lightMutedForeground,
                  ),
                ),
              ],
            ),
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'General Settings',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 24),
                  _SettingItem(
                    title: 'Application Name',
                    description: 'The name of your application',
                    trailing: const Text('Bullsassets Admin Panel'),
                  ),
                  const Divider(height: 32),
                  _SettingItem(
                    title: 'Email Notifications',
                    description:
                        'Receive email notifications for important updates',
                    trailing: Switch(value: true, onChanged: (_) {}),
                  ),
                  const Divider(height: 32),
                  _SettingItem(
                    title: 'Push Notifications',
                    description: 'Receive push notifications on your device',
                    trailing: Switch(value: true, onChanged: (_) {}),
                  ),
                  const Divider(height: 32),
                  _SettingItem(
                    title: 'Dark Mode',
                    description: 'Enable dark mode for the application',
                    trailing: Switch(value: false, onChanged: (_) {}),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    'Account Settings',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 24),
                  _SettingItem(
                    title: 'Change Password',
                    description: 'Update your account password',
                    trailing: OutlinedButton(
                      onPressed: () {},
                      child: const Text('Change'),
                    ),
                  ),
                  const Divider(height: 32),
                  _SettingItem(
                    title: 'Two-Factor Authentication',
                    description:
                        'Add an extra layer of security to your account',
                    trailing: OutlinedButton(
                      onPressed: () {},
                      child: const Text('Enable'),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Divider(color: AppColors.lightBorder),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.statusError,
                    ),
                    child: const Text('Sign Out'),
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

class _SettingItem extends StatelessWidget {
  final String title;
  final String description;
  final Widget trailing;

  const _SettingItem({
    required this.title,
    required this.description,
    required this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(
                  color: AppColors.lightMutedForeground,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        trailing,
      ],
    );
  }
}
