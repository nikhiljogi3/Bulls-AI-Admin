# Bulls Assets Admin Panel - Flutter Implementation

## Overview

This is a complete rewrite of the Bulls Assets Admin Panel from React/TypeScript to Flutter (Dart). The application maintains the same design language, color scheme, and functionality as the original React application.

## Key Features

- **Dashboard**: Overview of academy performance with stats, revenue charts, and recent sales
- **Students Management**: View, search, and manage student enrollments
- **Content & Courses**: Manage courses, videos, and educational content
- **Advisory & Tips**: Manage stock recommendations and trading tips
- **Payments**: Track all payment transactions and subscription history
- **Announcements**: Send push notifications and manage student communications
- **Settings**: Application configuration and account management

## Design System

### Colors

- **Primary Green**: #199955 (Bullsassets brand color)
- **Dark Sidebar**: #1E293B
- **Background**: #FAFAFA
- **Success**: #10B981
- **Error**: #F87171
- **Warning**: #FCD34D

### Typography

- **Primary Font**: Inter (body), Plus Jakarta Sans (headings)
- **Light Mode**: Clean white backgrounds with dark text
- **Responsive**: Desktop, tablet, and mobile support

## Project Structure

```
lib/
├── main.dart                 # App entry point with routing
├── theme/
│   ├── app_colors.dart      # Color definitions
│   └── app_theme.dart       # Material theme configuration
├── screens/
│   ├── dashboard_screen.dart
│   ├── students_screen.dart
│   ├── announcements_screen.dart
│   ├── advisory_screen.dart
│   ├── content_screen.dart
│   ├── payments_screen.dart
│   └── settings_screen.dart
├── widgets/
│   └── admin_layout.dart     # Sidebar + Header layout
├── models/
│   ├── student_model.dart
│   ├── course_model.dart
│   ├── advisory_model.dart
│   ├── notification_model.dart
│   ├── payment_model.dart
│   └── user_model.dart
├── constants/
│   └── app_constants.dart    # Navigation items and mock data
├── providers/
│   ├── user_provider.dart
│   ├── course_provider.dart
│   ├── live_class_provider.dart
│   └── notification_provider.dart
└── services/
    └── [Firebase integration services]
```

## Firebase Integration

The app is fully configured for Firebase with:

- **Cloud Firestore**: Database for all entities (students, courses, payments, etc.)
- **Firebase Auth**: User authentication
- **Firebase Core**: Initialization

Configuration files are located in:

- `firebase_options.dart` - Platform-specific Firebase configuration
- `pubspec.yaml` - Firebase dependencies

## Getting Started

### Prerequisites

- Flutter SDK (3.10.4 or higher)
- Dart SDK
- Firebase project setup

### Installation

1. Install dependencies:

```bash
cd web_admin_bulls_asset
flutter pub get
```

2. Configure Firebase:

- Ensure `google-services.json` (Android) and `GoogleService-Info.plist` (iOS) are properly placed
- Run `flutterfire configure` if needed

3. Run the app:

```bash
flutter run
```

## Data Models

### Student

- ID, Name, Email, Batch
- Status (Active, Inactive, Pending)
- Joined Date, Phone Number

### Course

- ID, Title, Description
- Video Count, Student Count
- Price, Instructor, Modules

### Advisory

- Stock Symbol, Type (BUY/SELL)
- Entry/Target/Stoploss Prices
- Status, Date, Analysis

### Payment

- Student ID/Name, Course ID/Name
- Amount, Status
- Payment Date, Method, Transaction ID

### Notification

- Title, Message, Type
- Recipient Group, Sent Status
- Creation Date

## State Management

The app uses **Provider** for state management with dedicated providers for:

- `CourseProvider` - Course data management
- `UserProvider` - User/Student data management
- `LiveClassProvider` - Live class data
- `NotificationProvider` - Notifications

## Navigation

The app uses Flutter's named route navigation:

- `/` - Dashboard
- `/students` - Students Management
- `/content` - Content & Courses
- `/advisory` - Advisory & Tips
- `/payments` - Payments
- `/announcements` - Announcements
- `/settings` - Settings

## Responsive Design

The layout is fully responsive:

- **Desktop (>1200px)**: Full sidebar + main content
- **Tablet (768-1200px)**: Collapsible sidebar
- **Mobile (<768px)**: Mobile-optimized navigation

## Future Enhancements

- [ ] Real-time data sync with Firebase
- [ ] Advanced reporting and analytics
- [ ] PDF export functionality
- [ ] Email integration for announcements
- [ ] Calendar integration for live classes
- [ ] Dark mode support
- [ ] Multi-language support

## Notes

- All mock data is currently hardcoded but ready to be replaced with Firebase queries
- The Firebase backend shares the same database with the original React application
- Services layer can be extended to include more complex business logic
- All UI components follow Material 3 design principles

## Support

For issues or questions about the implementation, refer to:

- Flutter Documentation: https://flutter.dev/docs
- Firebase Flutter: https://firebase.flutter.dev
- Provider Package: https://pub.dev/packages/provider
