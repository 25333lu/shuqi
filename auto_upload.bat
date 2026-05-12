@echo off
echo ========================================
echo 纾炽Ai绘图 - 自动上传到GitHub
echo ========================================
echo.

:: 检查必要的工具
echo 检查工具...
where curl >nul 2>&1
if %errorlevel% neq 0 (
    echo 错误: 未找到curl工具
    echo 请安装curl: https://curl.se/windows/
    pause
    exit /b 1
)

where git >nul 2>&1
if %errorlevel% neq 0 (
    echo 警告: 未找到Git工具，将使用GitHub API直接上传
    set USE_GIT_API=1
) else (
    echo Git工具已找到
    set USE_GIT_API=0
)

echo.

:: 设置变量
set GITHUB_USER=25333lu
set GITHUB_REPO=shuqi
set GITHUB_TOKEN=YOUR_GITHUB_TOKEN_HERE
set REPO_URL=https://github.com/%GITHUB_USER%/%GITHUB_REPO%.git
set API_URL=https://api.github.com/repos/%GITHUB_USER%/%GITHUB_REPO%

echo 目标仓库: %REPO_URL%
echo.

:: 检查GitHub Token
if "%GITHUB_TOKEN%"=="YOUR_GITHUB_TOKEN_HERE" (
    echo 错误: 请先设置GitHub Token
    echo.
    echo 获取GitHub Token的步骤:
    echo 1. 登录GitHub: https://github.com
    echo 2. 进入 Settings > Developer settings > Personal access tokens
    echo 3. 点击 "Generate new token"
    echo 4. 选择 "repo" 权限
    echo 5. 生成并复制Token
    echo.
    echo 请将脚本中的 YOUR_GITHUB_TOKEN_HERE 替换为您的实际Token
    pause
    exit /b 1
)

:: 创建项目包
echo 创建项目包...
if not exist "upload_package" mkdir upload_package
xcopy /E /I /Y "." "upload_package\" >nul

cd upload_package

if %USE_GIT_API%==0 (
    echo 使用Git方式上传...
    
    :: 初始化Git仓库
    git init
    
    :: 添加远程仓库
    git remote add origin %REPO_URL%
    
    :: 添加所有文件
    git add .
    
    :: 提交
    git commit -m "纾炽Ai绘图 - 自动上传

- 添加完整的AI图像生成功能
- 支持Nano Banana Pro和GPT Image 2两种模型
- 响应式设计，支持桌面和移动设备
- 包含历史记录、图片管理等功能
- 更新品牌信息为纾炽Ai绘图"
    
    :: 推送到GitHub
    git push -u origin main
    
    echo.
    echo ✅ 上传完成！
) else (
    echo 使用GitHub API方式上传...
    
    :: 创建GitHub仓库
    echo 创建GitHub仓库...
    curl -X POST -H "Authorization: token %GITHUB_TOKEN%" -H "Accept: application/vnd.github.v3+json" %API_URL% -d '{"name":"%GITHUB_REPO%","auto_init":true}' >nul 2>&1
    
    :: 创建并上传文件
    echo 上传项目文件...
    
    :: 上传index.html
    curl -X PUT -H "Authorization: token %GITHUB_TOKEN%" -H "Accept: application/vnd.github.v3+json" "%API_URL%/contents/index.html" -d '{"message":"上传index.html","content":"'"$(base64 -w 0 index.html)"'","branch":"main"}' >nul 2>&1
    
    :: 上传favicon.ico
    curl -X PUT -H "Authorization: token %GITHUB_TOKEN%" -H "Accept: application/vnd.github.v3+json" "%API_URL%/contents/favicon.ico" -d '{"message":"上传favicon.ico","content":"'"$(base64 -w 0 favicon.ico)"'","branch":"main"}' >nul 2>&1
    
    :: 上传README.md
    curl -X PUT -H "Authorization: token %GITHUB_TOKEN%" -H "Accept: application/vnd.github.v3+json" "%API_URL%/contents/README.md" -d '{"message":"上传README.md","content":"'"$(base64 -w 0 README.md)"'","branch":"main"}' >nul 2>&1
    
    :: 上传.gitignore
    curl -X PUT -H "Authorization: token %GITHUB_TOKEN%" -H "Accept: application/vnd.github.v3+json" "%API_URL%/contents/.gitignore" -d '{"message":"上传.gitignore","content":"'"$(base64 -w 0 .gitignore)"'","branch":"main"}' >nul 2>&1
    
    echo.
    echo ✅ 上传完成！
)

echo.
echo 🎉 项目已成功上传到: https://github.com/%GITHUB_USER%/%GITHUB_REPO%
echo.
echo 访问您的项目: https://github.com/%GITHUB_USER%/%GITHUB_REPO%
echo.

cd ..
pause