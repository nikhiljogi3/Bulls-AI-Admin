# Netlify CI Deploy Setup

This project includes a GitHub Actions workflow that will build the Flutter web app and deploy to Netlify when you push to `main`.

## What I added

- `.github/workflows/netlify-deploy.yml` — builds `flutter build web --release` and deploys the `build/web` output to Netlify using the Netlify CLI.
- `netlify.toml` — configures Netlify build/publish folder and adds SPA rewrite rules.

## Required actions (Netlify + GitHub)

1. Create a Netlify account (https://app.netlify.com/).
2. Create a site on Netlify (any site, you can create an empty one now). Note its **Site ID**: in the Site dashboard, go to **Site settings → Site information → Site ID**.
3. Create a Personal Access Token in Netlify:
   - Go to **User settings → Applications → Personal access tokens** → **New access token**. Save the token (you will only see it once).
4. In your GitHub repo, add two repository secrets:
   - `NETLIFY_AUTH_TOKEN` — paste the personal access token value
   - `NETLIFY_SITE_ID` — paste the Site ID
     (GitHub: repo → Settings → Secrets and variables → Actions → New repository secret)
5. Push (or merge) to `main`. The GitHub Action will run, build the web app, and deploy to the Netlify site.

## Alternative: Drag & Drop (no Git required)

1. Build locally: `flutter build web --release` (produces `build/web`).
2. In Netlify, **Sites → Add new site → Deploy manually** and drag the contents of the `build/web` folder.

## Notes & Troubleshooting

- The GitHub Actions runner includes Node/npm, so the workflow uses `npx netlify-cli` (no global npm install required).
- If your default branch isn't `main`, edit the workflow `on.push.branches` to match your deploy branch.
- If you prefer Netlify to build from your repo directly, you can also connect the repository inside Netlify and set the build command to:
  - Build command: `flutter build web --release`
  - Publish directory: `build/web`

If you want, I can add the `NETLIFY_AUTH_TOKEN` and `NETLIFY_SITE_ID` for you if you paste them here (or provide them securely). Otherwise, follow the steps above and push to `main` to trigger a build & deploy.
