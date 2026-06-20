@echo off
chcp 65001 >nul
title AI 启动菜单
setlocal enabledelayedexpansion

:: ===== 自动检测路径 =====
set "BASE=%~dp0"
set "LLAMA=%BASE%llamacpp\llama-server.exe"
set "MODELS=%BASE%models"

:: 检测 llama-server.exe
if not exist "%LLAMA%" (
    echo [错误] 找不到 llamacpp\llama-server.exe
    echo 请确保目录结构如下：
    echo   AI\
    echo   AI\llamacpp\llama-server.exe
    echo   AI\models\你的模型.gguf
    echo   AI\启动AI.bat   ^<-- 本文件
    pause & exit
)

:: 检测 open-webui
for /f "delims=" %%i in ('where open-webui 2^>nul') do set "WEBUI=%%i"
if not defined WEBUI (
    echo [错误] 找不到 open-webui
    echo 请先安装：pip install open-webui
    pause & exit
)

:: 扫描 models 文件夹里的 GGUF 文件
set count=0
for %%f in ("%MODELS%\*.gguf") do (
    set /a count+=1
    set "model_!count!=%%~nxf"
)

if %count%==0 (
    echo [错误] models 文件夹里没有找到任何 .gguf 模型文件
    pause & exit
)

:menu
cls
echo ============================================
echo           AI 本地模型启动菜单
echo ============================================
echo.
echo  检测到以下模型：
echo.
for /l %%i in (1,1,%count%) do (
    echo  [%%i] !model_%%i!
)
echo  [0] 退出
echo.
set /p choice=请输入数字后按回车：

if "%choice%"=="0" exit
if not defined choice goto menu

set /a check=%choice% 2>nul
if %check% LSS 1 goto invalid
if %check% GTR %count% goto invalid

set "selected=!model_%choice%!"
goto launch

:invalid
echo 输入无效，请重新选择
timeout /t 2 >nul
goto menu

:launch
cls
echo 正在启动：%selected%
echo 稍后请打开浏览器访问 http://localhost:8080
echo.
start "Open WebUI" cmd /k "%WEBUI% serve"
timeout /t 5 >nul
"%LLAMA%" ^
  --model "%MODELS%\%selected%" ^
  --ctx-size 16384 ^
  --n-gpu-layers 99 ^
  --threads 12 ^
  --cache-type-k q4_1 ^
  --cache-type-v q4_1 ^
  --flash-attn on ^
  --port 8081 ^
  --host 0.0.0.0
pause
