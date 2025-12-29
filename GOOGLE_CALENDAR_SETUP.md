# Google Calendar API Integration Setup

This document explains how to set up Google Calendar API integration for the Live Class feature with Google Meet.

## Features

- ✅ Automatic Google Meet link generation through Google Calendar API
- ✅ Calendar event creation and synchronization
- ✅ Attendee email invitations
- ✅ Event updates and deletions synced with Google Calendar
- ✅ OAuth 2.0 authentication for secure access

## Prerequisites

1. A Google Cloud Platform (GCP) project
2. Google Calendar API enabled
3. OAuth 2.0 credentials configured

## Setup Steps

### 1. Create a Google Cloud Project

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Click "Select a project" → "New Project"
3. Enter a project name (e.g., "Bulls Asset Admin")
4. Click "Create"

### 2. Enable Google Calendar API

1. In your GCP project, go to "APIs & Services" → "Library"
2. Search for "Google Calendar API"
3. Click on it and press "Enable"

### 3. Configure OAuth Consent Screen

1. Go to "APIs & Services" → "OAuth consent screen"
2. Choose "External" (or "Internal" if using Google Workspace)
3. Fill in the required information:
   - App name: Bulls Asset Admin
   - User support email: your email
   - Developer contact: your email
4. Add scopes:
   - `https://www.googleapis.com/auth/calendar`
   - `https://www.googleapis.com/auth/calendar.events`
5. Add test users (your email addresses)
6. Click "Save and Continue"

### 4. Create OAuth 2.0 Credentials

#### For Web App:

1. Go to "APIs & Services" → "Credentials"
2. Click "Create Credentials" → "OAuth client ID"
3. Choose "Web application"
4. Name: "Bulls Asset Web Client"
5. Add Authorized JavaScript origins:
   ```
   http://localhost
   http://localhost:3000
   http://localhost:8080
   ```
6. Add Authorized redirect URIs:
   ```
   http://localhost
   http://localhost:3000
   http://localhost:8080
   ```
7. Click "Create"
8. Copy the Client ID (you'll need this)

### 5. Configure the Flutter App

You need to update the OAuth configuration in your Flutter app:

#### For Web:

Create or update `web/index.html` to include your OAuth Client ID:

```html
<meta
  name="google-signin-client_id"
  content="YOUR_CLIENT_ID_HERE.apps.googleusercontent.com"
/>
```

#### Alternative: Environment Configuration

Create a `.env` file in the project root:

```env
GOOGLE_CLIENT_ID=your-client-id-here.apps.googleusercontent.com
```

### 6. Test the Integration

1. Run your Flutter app
2. Navigate to the "Live Class" section
3. Click "Connect Google" button
4. Sign in with your Google account
5. Grant the requested permissions
6. Create a new live class with "Create via Google Calendar" toggle enabled
7. Check your Google Calendar to verify the event was created

## Usage

### Creating a Live Class with Google Meet

1. **Sign in to Google**: Click the "Connect Google" button in the Live Class screen
2. **Create Live Class**: Click "Create Live Class"
3. **Enable Google Calendar**: Toggle "Create via Google Calendar" ON
4. **Fill in details**:
   - Class Title
   - Description
   - Scheduled Time
   - Duration (30, 60, 90, 120, or 180 minutes)
   - Attendee Emails (comma-separated)
5. **Save**: The system will automatically:
   - Create a Google Calendar event
   - Generate a Google Meet link
   - Send invitations to attendees
   - Store the event in Firestore

### Manual Meet Link

If you prefer to use a manually created Meet link:

1. Toggle "Create via Google Calendar" OFF
2. Enter your own Google Meet link
3. Save

### Editing a Live Class

- Changes made to the class will sync with Google Calendar if the event was created via the API
- The Google Meet link remains the same unless you create a new calendar event

### Deleting a Live Class

- Deleting a class will also remove the associated Google Calendar event
- Attendees will receive cancellation notifications

## Troubleshooting

### "Not authenticated" error

- Make sure you've signed in with Google
- Check that your OAuth credentials are correctly configured

### "Failed to create calendar event"

- Verify Google Calendar API is enabled in GCP
- Check that your OAuth scopes include calendar access
- Ensure your test users are added to the OAuth consent screen

### Meet link not generated

- Verify you have Google Workspace or Google Workspace Individual account (required for Meet)
- Check that the calendar event was created successfully
- Try creating a manual Meet link as fallback

## Production Deployment

### For Web Deployment:

1. Update Authorized Origins in GCP:

   ```
   https://yourdomain.com
   ```

2. Update Authorized Redirect URIs:

   ```
   https://yourdomain.com
   https://yourdomain.com/auth
   ```

3. Update your `web/index.html` with production Client ID

4. Submit app for OAuth verification if deploying publicly

## Security Considerations

- Never commit OAuth credentials to version control
- Use environment variables for sensitive data
- Implement proper user authentication
- Regularly rotate credentials
- Monitor API usage in GCP Console

## API Quotas

Google Calendar API has the following quotas:

- 1,000,000 queries per day (default)
- 10 queries per second per user

For higher limits, request a quota increase in the GCP Console.

## Support

For issues related to:

- Google Calendar API: [API Documentation](https://developers.google.com/calendar/api/guides/overview)
- OAuth 2.0: [OAuth Documentation](https://developers.google.com/identity/protocols/oauth2)
- Flutter Google Sign-In: [Package Documentation](https://pub.dev/packages/google_sign_in)

## Resources

- [Google Calendar API Reference](https://developers.google.com/calendar/api/v3/reference)
- [Google Meet Integration](https://developers.google.com/calendar/api/guides/create-events#conferencing)
- [Flutter OAuth Guide](https://pub.dev/packages/googleapis_auth)
