@echo off
chcp 65001 >nul
echo ========================================
echo Shuchi AI Drawing - Auto Upload Guide
echo ========================================
echo.

echo Project files ready:
echo    - index.html (main program)
echo    - favicon.ico (website icon)
echo    - README.md (project documentation)
echo    - .gitignore (git ignore rules)
echo.

echo Target repository: https://github.com/25333lu/shuqi
echo.

echo Upload Steps:
echo 1. Create GitHub repository manually: https://github.com/25333lu/shuqi
echo 2. Get GitHub Personal Access Token
echo 3. Use one of the following methods:
echo.
echo    Method A - Using Git (recommended):
echo    git init
echo    git add .
echo    git commit -m "Shuchi AI Drawing - Initial Release"
echo    git remote add origin https://github.com/25333lu/shuqi.git
echo    git push -u origin main
echo.
echo    Method B - Manual Upload:
echo    1. Visit: https://github.com/25333lu/shuqi
echo    2. Click "Add file" -^> "Upload files"
echo    3. Drag and drop all files
echo    4. Commit message: "Shuchi AI Drawing - Initial Release"
echo.
echo Auto-upload scripts created:
echo    - auto_upload.bat (Batch version)
echo    - auto_upload.ps1 (PowerShell version)
echo.
echo How to use:
echo 1. Edit YOUR_GITHUB_TOKEN_HERE in the scripts
echo 2. Run auto_upload.ps1 (recommended) or auto_upload.bat
echo 3. Follow the prompts to complete upload
echo.

echo Project files are ready!
echo.
pause