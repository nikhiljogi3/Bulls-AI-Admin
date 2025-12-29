# Bullsassets Admin Panel

Flutter web-based admin panel for managing courses, students, advisory tips, and live classes.

## 🚀 Deployment

This project is automatically deployed to GitHub Pages on every push to the main branch.

**Live URL:** `https://YOUR-USERNAME.github.io/web_admin_bulls_asset/`

## 📦 Manual Build & Deploy

```bash
# Build for production
flutter build web --release --base-href "/web_admin_bulls_asset/"

# Install gh-pages (first time only)
npm install -g gh-pages

# Deploy to GitHub Pages
gh-pages -d build/web
```

## 🛠️ Local Development

```bash
# Install dependencies
flutter pub get

# Run locally
flutter run -d chrome
```

## 📝 GitHub Pages Setup

1. Go to your repository Settings → Pages
2. Source: Deploy from a branch
3. Branch: `gh-pages` / `root`
4. Save

## 🔧 Technology Stack

- Flutter Web
- Firebase (Firestore, Auth)
- Provider (State Management)

## 📱 Features

- Dashboard with analytics
- Student management
- Course management
- Advisory tips management
- Live class scheduling
- Payment tracking

---

**Note:** Make sure to update the base-href in `.github/workflows/deploy.yml` and deployment commands to match your repository name.
