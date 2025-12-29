# Deploy to GitHub Pages Script
# Run this script to manually deploy to GitHub Pages

Write-Host "🚀 Building Flutter Web App..." -ForegroundColor Cyan
flutter build web --release --base-href "/Bulls-AI-Admin/"

if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Build completed successfully!" -ForegroundColor Green
    
    Write-Host "`n📦 Deploying to GitHub Pages..." -ForegroundColor Cyan
    
    # Check if gh-pages is installed
    $ghPagesInstalled = Get-Command gh-pages -ErrorAction SilentlyContinue
    
    if (-not $ghPagesInstalled) {
        Write-Host "⚠️  gh-pages not found. Installing..." -ForegroundColor Yellow
        npm install -g gh-pages
    }
    
    # Deploy
    gh-pages -d build/web
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "`n✅ Deployment successful!" -ForegroundColor Green
        Write-Host "🌐 Your site will be available at: https://nikhiljogi3.github.io/Bulls-AI-Admin/" -ForegroundColor Cyan
        Write-Host "`n⏱️  GitHub Pages may take a few minutes to update." -ForegroundColor Yellow
    }
    else {
        Write-Host "`n❌ Deployment failed!" -ForegroundColor Red
    }
}
else {
    Write-Host "`n❌ Build failed!" -ForegroundColor Red
}
