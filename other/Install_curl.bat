@echo off
setlocal EnableDelayedExpansion

:: ---- AUTO ELEVATE TO ADMIN ----
net session >nul 2>&1
if %errorLevel% NEQ 0 (
    echo [INFO] Requesting administrator privileges...
    powershell -NoProfile -ExecutionPolicy Bypass -Command "Start-Process -FilePath '%~f0' -Verb RunAs"
    exit /b
)

echo ============================================
echo              cURL Installer
echo ============================================
echo.

:: Check if curl is already installed
curl --version >nul 2>&1
if %errorLevel% EQU 0 (
    echo [INFO] curl is already installed:
    curl --version | findstr /i "curl"
    echo.
    choice /C YN /M "Do you want to reinstall/update curl?"
    if !errorLevel! EQU 2 (
        echo Exiting...
        pause
        exit /b 0
    )
)

:: Set variables
set "INSTALL_DIR=%SYSTEMROOT%\System32"
set "TEMP_DIR=%TEMP%\curl_install"
set "CURL_ZIP=%TEMP_DIR%\curl.zip"
set "EXTRACT_DIR=%TEMP_DIR%\extracted"

:: Clean up and recreate temp dir
if exist "%TEMP_DIR%" rd /s /q "%TEMP_DIR%"
mkdir "%TEMP_DIR%"
mkdir "%EXTRACT_DIR%"

echo [INFO] Downloading curl for Windows (64-bit)...
powershell -NoProfile -ExecutionPolicy Bypass -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri 'https://curl.se/windows/dl-8.11.1_1/curl-8.11.1_1-win64-mingw.zip' -OutFile '%CURL_ZIP%' -UseBasicParsing"

if not exist "%CURL_ZIP%" (
    echo [ERROR] Download failed. Check your internet connection.
    pause
    exit /b 1
)
echo [INFO] Download successful.

:: Extract using PowerShell
echo [INFO] Extracting archive...
powershell -NoProfile -ExecutionPolicy Bypass -Command "Expand-Archive -LiteralPath '%CURL_ZIP%' -DestinationPath '%EXTRACT_DIR%' -Force"

if %errorLevel% NEQ 0 (
    echo [ERROR] Expand-Archive failed.
    pause
    exit /b 1
)

:: Find curl.exe specifically inside a "bin" folder
echo [INFO] Locating curl.exe in bin folder...
set "CURL_BIN_SRC="
for /r "%EXTRACT_DIR%" %%F in (curl.exe) do (
    echo %%~dpF | findstr /i "\\bin\\" >nul
    if !errorLevel! EQU 0 (
        set "CURL_BIN_SRC=%%~dpF"
    )
)

if not defined CURL_BIN_SRC (
    echo [ERROR] Could not find curl.exe inside a bin folder.
    echo [DEBUG] All curl.exe locations found:
    for /r "%EXTRACT_DIR%" %%F in (curl.exe) do echo   %%F
    pause
    exit /b 1
)

echo [INFO] Found bin folder: %CURL_BIN_SRC%

:: Copy curl.exe and DLLs to System32
echo [INFO] Installing to %INSTALL_DIR%...
copy /Y "%CURL_BIN_SRC%curl.exe" "%INSTALL_DIR%\" >nul
copy /Y "%CURL_BIN_SRC%*.dll"    "%INSTALL_DIR%\" >nul 2>&1
copy /Y "%CURL_BIN_SRC%*.crt"    "%INSTALL_DIR%\" >nul 2>&1

if not exist "%INSTALL_DIR%\curl.exe" (
    echo [ERROR] Failed to copy curl.exe to %INSTALL_DIR%.
    pause
    exit /b 1
)

:: No PATH update needed - System32 is already in PATH

:: Cleanup
echo [INFO] Cleaning up temp files...
rd /s /q "%TEMP_DIR%" >nul 2>&1

echo.
echo ============================================
echo        Installation Complete!
echo ============================================
echo.
echo Installed to: %INSTALL_DIR%\curl.exe
echo.
curl --version
echo.
pause
exit /b 0
