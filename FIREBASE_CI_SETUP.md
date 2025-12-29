# CI / GitHub Actions: Firebase Hosting setup

This project contains a GitHub Actions workflow that will build the Flutter web app and deploy to Firebase Hosting when you push to `main`.

## What I added

- `.github/workflows/firebase-hosting.yml` — builds `flutter build web --release` and deploys to Firebase Hosting for project `bullsassets-b8018`.

## What you need to do

1. Create a Google service account with permissions to deploy to Firebase (recommended role: `Firebase Admin` or `Firebase Hosting Admin` / `Editor`).

   - Go to: https://console.cloud.google.com/iam-admin/serviceaccounts
   - Create service account, grant the role, and create a JSON key (private key). Save the JSON file.

2. Add a repository secret in GitHub:

   - In your GitHub repo: Settings → Secrets and variables → Actions → New repository secret
   - Name: `FIREBASE_SERVICE_ACCOUNT`
   - Value: paste the entire JSON key file contents

3. Push to `main` (or merge a PR into `main`). The workflow will run and deploy to Firebase Hosting automatically.

## Alternative: use a CI token

If you prefer, you can generate a CI token locally with `firebase login:ci` and add it as `FIREBASE_TOKEN` secret, but that requires installing the Firebase CLI locally.

---

If you'd like, I can also add a workflow that deploys only from a tag or from `gh-pages` branch; tell me which branch you prefer for deploys.
