@echo off
chcp 65001 >nul
title AI Launcher

setlocal enabledelayedexpansion

set "BASE=%~dp0"
set "LLAMA=%BASE%llamacpp\llama-server.exe"
set "MODELS=%BASE%models"

if not exist "%LLAMA%" (
    echo [ERROR] Cannot find llamacpp\llama-server.exe
    echo Please make sure the folder structure is:
    echo   AI\llamacpp\llama-server.exe
    echo   AI\models\yourmodel.gguf
    echo   AI\start.bat
    pause
    exit /b
)

for /f "delims=" %%i in ('where open-webui 2^>nul') do set "WEBUI=%%i"
if not defined WEBUI (
    echo [ERROR] open-webui not found
    echo Please install: pip install open-webui
    pause
    exit /b
)

set count=0
for %%f in ("%MODELS%\*.gguf") do (
    set /a count+=1
    set "model_!count!=%%~nxf"
)

if %count%==0 (
    echo [ERROR] No .gguf model files found in models folder
    pause
    exit /b
)

:menu
cls
echo ============================================
echo        AI Local Model Launcher
echo ============================================
echo.
echo  Select a model:
echo.
for /l %%i in (1,1,%count%) do (
    echo  [%%i] !model_%%i!
)
echo  [0] Exit
echo.
set "choice="
set /p choice=Enter number: 

if not defined choice goto menu
if "%choice%"=="0" exit /b

set /a check=%choice% 2>nul
if %check% LSS 1 goto invalid
if %check% GTR %count% goto invalid

set "selected=!model_%choice%!"
goto launch

:invalid
echo Invalid input, please try again.
timeout /t 2 >nul
goto menu

:launch
cls
echo Starting: %selected%
echo Please open browser and go to http://localhost:8080
echo.
start "Open WebUI" cmd /k "%WEBUI% serve"
timeout /t 5 >nul
"%LLAMA%" --model "%MODELS%\%selected%" --ctx-size 16384 --n-gpu-layers 99 --threads 12 --cache-type-k q4_1 --cache-type-v q4_1 --flash-attn on --port 8081 --host 0.0.0.0
pause
