# 纾炽Ai绘图 - 自动上传到GitHub
# 作者: 纾炽
# 微信: shuchi1016

Write-Host "========================================" -ForegroundColor Green
Write-Host "纾炽Ai绘图 - 自动上传到GitHub" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""

# 检查必要的工具
Write-Host "检查工具..." -ForegroundColor Yellow

# 检查Git
$gitAvailable = $false
try {
    git --version | Out-Null
    $gitAvailable = $true
    Write-Host "✅ Git工具已找到" -ForegroundColor Green
} catch {
    Write-Host "⚠️  Git工具未找到，将使用GitHub API直接上传" -ForegroundColor Yellow
}

# 检查curl
$curlAvailable = $false
try {
    curl --version | Out-Null
    $curlAvailable = $true
    Write-Host "✅ curl工具已找到" -ForegroundColor Green
} catch {
    Write-Host "❌ curl工具未找到" -ForegroundColor Red
    Write-Host "请安装curl: https://curl.se/windows/" -ForegroundColor Red
    Read-Host "按任意键退出"
    exit
}

Write-Host ""

# 设置变量
$githubUser = "25333lu"
$githubRepo = "shuqi"
$githubToken = "YOUR_GITHUB_TOKEN_HERE"
$repoUrl = "https://github.com/$githubUser/$githubRepo.git"
$apiUrl = "https://api.github.com/repos/$githubUser/$githubRepo"

Write-Host "目标仓库: $repoUrl" -ForegroundColor Cyan
Write-Host ""

# 检查GitHub Token
if ($githubToken -eq "YOUR_GITHUB_TOKEN_HERE") {
    Write-Host "❌ 错误: 请先设置GitHub Token" -ForegroundColor Red
    Write-Host ""
    Write-Host "获取GitHub Token的步骤:" -ForegroundColor Yellow
    Write-Host "1. 登录GitHub: https://github.com" -ForegroundColor White
    Write-Host "2. 进入 Settings > Developer settings > Personal access tokens" -ForegroundColor White
    Write-Host "3. 点击 'Generate new token'" -ForegroundColor White
    Write-Host "4. 选择 'repo' 权限" -ForegroundColor White
    Write-Host "5. 生成并复制Token" -ForegroundColor White
    Write-Host ""
    Write-Host "请将脚本中的 YOUR_GITHUB_TOKEN_HERE 替换为您的实际Token" -ForegroundColor White
    Read-Host "按任意键退出"
    exit
}

# 创建项目包
Write-Host "创建项目包..." -ForegroundColor Yellow
$uploadDir = "upload_package"
if (-not (Test-Path $uploadDir)) {
    New-Item -ItemType Directory -Path $uploadDir | Out-Null
}

Copy-Item -Path ".\*" -Destination $uploadDir -Recurse -Force | Out-Null
Set-Location $uploadDir

if ($gitAvailable) {
    Write-Host "使用Git方式上传..." -ForegroundColor Green
    
    # 初始化Git仓库
    git init | Out-Null
    
    # 配置用户信息
    git config user.name "25333lu" | Out-Null
    git config user.email "your-email@example.com" | Out-Null
    
    # 添加远程仓库
    git remote add origin $repoUrl | Out-Null
    
    # 添加所有文件
    git add . | Out-Null
    
    # 提交
    git commit -m "纾炽Ai绘图 - 自动上传`n`n- 添加完整的AI图像生成功能`n- 支持Nano Banana Pro和GPT Image 2两种模型`n- 响应式设计，支持桌面和移动设备`n- 包含历史记录、图片管理等功能`n- 更新品牌信息为纾炽Ai绘图" | Out-Null
    
    # 推送到GitHub
    git push -u origin main | Out-Null
    
    Write-Host "" -ForegroundColor Green
    Write-Host "✅ Git上传完成！" -ForegroundColor Green
} else {
    Write-Host "使用GitHub API方式上传..." -ForegroundColor Green
    
    # 创建GitHub仓库
    Write-Host "创建GitHub仓库..." -ForegroundColor Yellow
    $body = @{
        name = $githubRepo
        auto_init = $true
    } | ConvertTo-Json
    
    try {
        Invoke-RestMethod -Uri $apiUrl -Method POST -Headers @{
            "Authorization" = "token $githubToken"
            "Accept" = "application/vnd.github.v3+json"
        } -Body $body | Out-Null
        Write-Host "✅ 仓库创建成功" -ForegroundColor Green
    } catch {
        Write-Host "⚠️  仓库可能已存在，继续上传..." -ForegroundColor Yellow
    }
    
    # 上传文件函数
    function Upload-File {
        param($filePath, $message)
        
        if (-not (Test-Path $filePath)) {
            Write-Host "⚠️  文件不存在: $filePath" -ForegroundColor Yellow
            return
        }
        
        $fileName = Split-Path $filePath -Leaf
        $fileContent = Get-Content $filePath -Raw
        $base64Content = [Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes($fileContent))
        
        $body = @{
            message = $message
            content = $base64Content
            branch = "main"
        } | ConvertTo-Json
        
        try {
            Invoke-RestMethod -Uri "$apiUrl/contents/$fileName" -Method PUT -Headers @{
                "Authorization" = "token $githubToken"
                "Accept" = "application/vnd.github.v3+json"
            } -Body $body | Out-Null
            Write-Host "✅ 上传成功: $fileName" -ForegroundColor Green
        } catch {
            Write-Host "❌ 上传失败: $fileName" -ForegroundColor Red
            Write-Host "错误: $_" -ForegroundColor Red
        }
    }
    
    # 上传所有文件
    Write-Host "上传项目文件..." -ForegroundColor Yellow
    Upload-File "index.html" "上传index.html"
    Upload-File "favicon.ico" "上传favicon.ico"
    Upload-File "README.md" "上传README.md"
    Upload-File ".gitignore" "上传.gitignore"
    
    Write-Host "" -ForegroundColor Green
    Write-Host "✅ API上传完成！" -ForegroundColor Green
}

Write-Host ""
Write-Host "🎉 项目已成功上传到: https://github.com/$githubUser/$githubRepo" -ForegroundColor Green
Write-Host ""
Write-Host "访问您的项目: https://github.com/$githubUser/$githubRepo" -ForegroundColor Cyan
Write-Host ""

Set-Location ..

# 清理临时文件
Remove-Item -Path $uploadDir -Recurse -Force | Out-Null

Read-Host "按任意键退出"