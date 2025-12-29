import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_admin_bulls_asset/firebase_options.dart';
import 'package:web_admin_bulls_asset/providers/course_provider.dart';
import 'package:web_admin_bulls_asset/providers/live_class_provider.dart';
import 'package:web_admin_bulls_asset/providers/advisory_provider.dart';
import 'package:web_admin_bulls_asset/providers/user_provider.dart';
import 'package:web_admin_bulls_asset/providers/notification_provider.dart';
import 'package:web_admin_bulls_asset/theme/app_theme.dart';
import 'package:web_admin_bulls_asset/screens/dashboard_screen.dart';
import 'package:web_admin_bulls_asset/screens/students_screen.dart';
import 'package:web_admin_bulls_asset/screens/announcements_screen.dart';
import 'package:web_admin_bulls_asset/screens/advisory_screen.dart';
import 'package:web_admin_bulls_asset/screens/content_screen.dart';
import 'package:web_admin_bulls_asset/screens/payments_screen.dart';
import 'package:web_admin_bulls_asset/screens/settings_screen.dart';
import 'package:web_admin_bulls_asset/screens/courses_screen.dart';
import 'package:web_admin_bulls_asset/screens/live_classes_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CourseProvider()),
        ChangeNotifierProvider(create: (context) => LiveClassProvider()),
        ChangeNotifierProvider(create: (context) => AdvisoryProvider()),
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => NotificationProvider()),
      ],
      child: MaterialApp(
        title: 'Bullsassets Admin Panel',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.light,
        initialRoute: '/',
        onGenerateRoute: (settings) {
          final routes = {
            '/': const DashboardScreen(),
            '/courses': const CoursesScreen(),
            '/live-classes': const LiveClassesScreen(),
            '/students': const StudentsScreen(),
            '/announcements': const AnnouncementsScreen(),
            '/advisory': const AdvisoryScreen(),
            '/content': const ContentScreen(),
            '/payments': const PaymentsScreen(),
            '/settings': const SettingsScreen(),
          };

          final widget = routes[settings.name];
          if (widget != null) {
            return PageRouteBuilder(
              settings: settings,
              pageBuilder: (context, animation, secondaryAnimation) => widget,
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                    const begin = Offset(0.02, 0.0);
                    const end = Offset.zero;
                    const curve = Curves.easeInOutCubic;

                    var tween = Tween(
                      begin: begin,
                      end: end,
                    ).chain(CurveTween(curve: curve));
                    var offsetAnimation = animation.drive(tween);

                    var fadeTween = Tween(
                      begin: 0.0,
                      end: 1.0,
                    ).chain(CurveTween(curve: curve));
                    var fadeAnimation = animation.drive(fadeTween);

                    return FadeTransition(
                      opacity: fadeAnimation,
                      child: SlideTransition(
                        position: offsetAnimation,
                        child: child,
                      ),
                    );
                  },
              transitionDuration: const Duration(milliseconds: 300),
            );
          }
          return null;
        },
      ),
    );
  }
}
