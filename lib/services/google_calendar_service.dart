import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/calendar/v3.dart' as calendar;

class GoogleCalendarService {
  static final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      calendar.CalendarApi.calendarScope,
      'https://www.googleapis.com/auth/calendar.events',
    ],
  );

  calendar.CalendarApi? _calendarApi;
  bool _isAuthenticated = false;

  bool get isAuthenticated => _isAuthenticated;

  // Sign in and get authenticated calendar API
  Future<bool> signIn() async {
    try {
      final account = await _googleSignIn.signIn();
      if (account == null) {
        return false;
      }

      final httpClient = (await _googleSignIn.authenticatedClient())!;
      _calendarApi = calendar.CalendarApi(httpClient);
      _isAuthenticated = true;
      return true;
    } catch (e) {
      print('Error signing in: $e');
      _isAuthenticated = false;
      return false;
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _googleSignIn.signOut();
    _isAuthenticated = false;
    _calendarApi = null;
  }

  // Check if user is already signed in
  Future<bool> checkSignIn() async {
    try {
      final account = _googleSignIn.currentUser;
      if (account != null) {
        final httpClient = (await _googleSignIn.authenticatedClient())!;
        _calendarApi = calendar.CalendarApi(httpClient);
        _isAuthenticated = true;
        return true;
      }
      return false;
    } catch (e) {
      print('Error checking sign in: $e');
      return false;
    }
  }

  // Create a Google Calendar event with Google Meet
  Future<Map<String, String>?> createMeetEvent({
    required String title,
    required String description,
    required DateTime startTime,
    required int durationMinutes,
    List<String>? attendeeEmails,
  }) async {
    if (!_isAuthenticated || _calendarApi == null) {
      throw Exception('Not authenticated. Please sign in first.');
    }

    try {
      final endTime = startTime.add(Duration(minutes: durationMinutes));

      // Create calendar event with Google Meet conference
      final event = calendar.Event()
        ..summary = title
        ..description = description
        ..start = calendar.EventDateTime(dateTime: startTime, timeZone: 'UTC')
        ..end = calendar.EventDateTime(dateTime: endTime, timeZone: 'UTC')
        ..conferenceData = calendar.ConferenceData(
          createRequest: calendar.CreateConferenceRequest(
            requestId: '${DateTime.now().millisecondsSinceEpoch}',
            conferenceSolutionKey: calendar.ConferenceSolutionKey(
              type: 'hangoutsMeet',
            ),
          ),
        );

      // Add attendees if provided
      if (attendeeEmails != null && attendeeEmails.isNotEmpty) {
        event.attendees = attendeeEmails
            .map((email) => calendar.EventAttendee(email: email))
            .toList();
      }

      // Insert event with conference data
      final createdEvent = await _calendarApi!.events.insert(
        event,
        'primary',
        conferenceDataVersion: 1,
        sendUpdates: 'all',
      );

      // Extract Google Meet link
      final meetLink =
          createdEvent.hangoutLink ??
          createdEvent.conferenceData?.entryPoints
              ?.firstWhere(
                (entry) => entry.entryPointType == 'video',
                orElse: () => calendar.EntryPoint(),
              )
              .uri ??
          '';

      return {
        'eventId': createdEvent.id ?? '',
        'meetLink': meetLink,
        'htmlLink': createdEvent.htmlLink ?? '',
      };
    } catch (e) {
      print('Error creating calendar event: $e');
      rethrow;
    }
  }

  // Update an existing calendar event
  Future<Map<String, String>?> updateMeetEvent({
    required String eventId,
    required String title,
    required String description,
    required DateTime startTime,
    required int durationMinutes,
    List<String>? attendeeEmails,
  }) async {
    if (!_isAuthenticated || _calendarApi == null) {
      throw Exception('Not authenticated. Please sign in first.');
    }

    try {
      final endTime = startTime.add(Duration(minutes: durationMinutes));

      // Get existing event
      final existingEvent = await _calendarApi!.events.get('primary', eventId);

      // Update event details
      existingEvent.summary = title;
      existingEvent.description = description;
      existingEvent.start = calendar.EventDateTime(
        dateTime: startTime,
        timeZone: 'UTC',
      );
      existingEvent.end = calendar.EventDateTime(
        dateTime: endTime,
        timeZone: 'UTC',
      );

      // Update attendees if provided
      if (attendeeEmails != null && attendeeEmails.isNotEmpty) {
        existingEvent.attendees = attendeeEmails
            .map((email) => calendar.EventAttendee(email: email))
            .toList();
      }

      // Update event
      final updatedEvent = await _calendarApi!.events.update(
        existingEvent,
        'primary',
        eventId,
        conferenceDataVersion: 1,
        sendUpdates: 'all',
      );

      // Extract Google Meet link
      final meetLink =
          updatedEvent.hangoutLink ??
          updatedEvent.conferenceData?.entryPoints
              ?.firstWhere(
                (entry) => entry.entryPointType == 'video',
                orElse: () => calendar.EntryPoint(),
              )
              .uri ??
          '';

      return {
        'eventId': updatedEvent.id ?? '',
        'meetLink': meetLink,
        'htmlLink': updatedEvent.htmlLink ?? '',
      };
    } catch (e) {
      print('Error updating calendar event: $e');
      rethrow;
    }
  }

  // Delete a calendar event
  Future<void> deleteMeetEvent(String eventId) async {
    if (!_isAuthenticated || _calendarApi == null) {
      throw Exception('Not authenticated. Please sign in first.');
    }

    try {
      await _calendarApi!.events.delete('primary', eventId, sendUpdates: 'all');
    } catch (e) {
      print('Error deleting calendar event: $e');
      rethrow;
    }
  }

  // Get current user email
  String? getUserEmail() {
    return _googleSignIn.currentUser?.email;
  }

  // Get current user display name
  String? getUserName() {
    return _googleSignIn.currentUser?.displayName;
  }
}
