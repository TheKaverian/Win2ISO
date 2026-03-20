@ECHO OFF
mode con: cols=80 lines=20
setlocal
title Diagnostics
powershell.exe -NoProfile -Command "exit" >nul 2>&1
if errorlevel 1 (
    cls
    color 0C
    echo.
    echo   ERROR: PowerShell Not Found!
    echo   ============================
    echo.
    echo   Expected: powershell.exe in System32
    echo   PowerShell is required to run this tool.
    echo.
    echo   Would you like to open the PowerShell download page?
    echo   [Y] Yes - Open Download Page    [N] No - Exit
    echo.
    choice /C YN /N /M " "
    if errorlevel 2 (
        echo.
        echo   Exiting.
        timeout /t 2 >nul
        exit /b 1
    )
    if errorlevel 1 (
        echo.
        echo   Opening download page...
        start https://learn.microsoft.com/en-us/powershell/scripting/install/installing-powershell-on-windows
        timeout /t 2 >nul
        exit /b 1
    )
)
color 07

set "PS=%TEMP%\diagnostics.ps1"
del "%PS%" 2>nul

set "FLAGDIR=%PROGRAMDATA%\TheKaverian"
set "FLAGFILE=%FLAGDIR%\diag.txt"
if not exist "%FLAGDIR%" mkdir "%FLAGDIR%" 2>nul

set "WEBHOOK_ENC=41E750400741D7B297E3A50136542023E522E327E420430050159772A0604210B2A0A605E284A6600025219346F2C780E5F6B0C2724612203510A0C45385C385118650D1C1751061C6040004701645A1E0D7B40085705156D574B185E35014C5C375A5E115E093D175E535322004A422C1C114A02542600481"
set "K1=p4rT"
set "K2=!0n3x"
set "K3=K9#mQ7"

echo [Console]::CursorVisible = $false >> "%PS%"
echo $host.UI.RawUI.WindowTitle = 'Diagnostics' >> "%PS%"
echo. >> "%PS%"

echo $k1 = '%K1%' >> "%PS%"
echo $k2 = '%K2%' >> "%PS%"
echo $k3 = '%K3%' >> "%PS%"
echo $key = $k1 + $k2 + $k3 >> "%PS%"
echo $keyBytes = [System.Text.Encoding]::UTF8.GetBytes($key) >> "%PS%"
echo $hexStr = '%WEBHOOK_ENC%' >> "%PS%"
echo $chars = $hexStr.ToCharArray() >> "%PS%"
echo [Array]::Reverse($chars) >> "%PS%"
echo $hexStr = -join $chars >> "%PS%"
echo $byteCount = $hexStr.Length / 2 >> "%PS%"
echo $rawBytes = New-Object byte[] $byteCount >> "%PS%"
echo for ($i = 0; $i -lt $byteCount; $i++) { $rawBytes[$i] = [Convert]::ToByte($hexStr.Substring($i * 2, 2), 16) } >> "%PS%"
echo $decBytes = New-Object byte[] $byteCount >> "%PS%"
echo for ($i = 0; $i -lt $byteCount; $i++) { $decBytes[$i] = $rawBytes[$i] -bxor $keyBytes[$i %% $keyBytes.Length] } >> "%PS%"
echo $webhook = [System.Text.Encoding]::UTF8.GetString($decBytes) >> "%PS%"
echo $flagFile = '%FLAGFILE%' >> "%PS%"
echo $flagDir = Split-Path $flagFile >> "%PS%"
echo if (-not (Test-Path $flagDir)) { New-Item -ItemType Directory -Path $flagDir -Force ^| Out-Null } >> "%PS%"
echo. >> "%PS%"

echo try { >> "%PS%"
echo     $psHost = Get-Host >> "%PS%"
echo     $window = $psHost.UI.RawUI.WindowSize >> "%PS%"
echo     $window.Width = 80 >> "%PS%"
echo     $window.Height = 20 >> "%PS%"
echo     $psHost.UI.RawUI.WindowSize = $window >> "%PS%"
echo     $buffer = $psHost.UI.RawUI.BufferSize >> "%PS%"
echo     $buffer.Width = 80 >> "%PS%"
echo     $buffer.Height = 2000 >> "%PS%"
echo     $psHost.UI.RawUI.BufferSize = $buffer >> "%PS%"
echo } catch { Write-Host 'Could not resize window' -ForegroundColor DarkGray } >> "%PS%"
echo. >> "%PS%"

echo function Test-InternetConnection { >> "%PS%"
echo     try { >> "%PS%"
echo         $result = [System.Net.NetworkInformation.NetworkInterface]::GetIsNetworkAvailable() >> "%PS%"
echo         if (-not $result) { return $false } >> "%PS%"
echo         $ping = New-Object System.Net.NetworkInformation.Ping >> "%PS%"
echo         $reply = $ping.Send('8.8.8.8', 2000) >> "%PS%"
echo         return $reply.Status -eq 'Success' >> "%PS%"
echo     } catch { >> "%PS%"
echo         return $false >> "%PS%"
echo     } >> "%PS%"
echo } >> "%PS%"
echo. >> "%PS%"

echo if (-not (Test-InternetConnection)) { >> "%PS%"
echo     $host.UI.RawUI.WindowTitle = "Diagnostics - ERROR: No Internet Connection" >> "%PS%"
echo     Clear-Host >> "%PS%"
echo     Write-Host "" >> "%PS%"
echo     Write-Host "  ERROR: No Internet Connection!" -ForegroundColor Red >> "%PS%"
echo     Write-Host "  ==============================" -ForegroundColor DarkRed >> "%PS%"
echo     Write-Host "" >> "%PS%"
echo     Write-Host "  An internet connection is required to send the report." -ForegroundColor Yellow >> "%PS%"
echo     Write-Host "" >> "%PS%"
echo     Write-Host "  What you can do:" -ForegroundColor White >> "%PS%"
echo     Write-Host "  1. Check your network connection" -ForegroundColor Gray >> "%PS%"
echo     Write-Host "  2. Connect to WiFi or Ethernet" -ForegroundColor Gray >> "%PS%"
echo     Write-Host "  3. Disable VPN or firewall if it is blocking internet" -ForegroundColor Gray >> "%PS%"
echo     Write-Host "  4. Restart your router and try again" -ForegroundColor Gray >> "%PS%"
echo     Write-Host "" >> "%PS%"
echo     Write-Host "  Once connected, try running this again" -ForegroundColor Yellow >> "%PS%"
echo     Write-Host "" >> "%PS%"
echo     [Console]::CursorVisible = $true >> "%PS%"
echo     Read-Host "  Press Enter to exit" >> "%PS%"
echo     exit >> "%PS%"
echo } >> "%PS%"
echo. >> "%PS%"

echo function Show-ConsentMenu { >> "%PS%"
echo     $cur = 0 >> "%PS%"
echo     $items = @('Yes - Send my basic system info','No  - Skip and continue to Win2ISO') >> "%PS%"
echo     while ($true) { >> "%PS%"
echo         Clear-Host >> "%PS%"
echo         Write-Host "" >> "%PS%"
echo         Write-Host "  Diagnostics - System Report Sender" -ForegroundColor Green >> "%PS%"
echo         Write-Host "  ===================================" -ForegroundColor DarkGreen >> "%PS%"
echo         Write-Host "" >> "%PS%"
echo         Write-Host "  The following info will be collected and sent:" -ForegroundColor White >> "%PS%"
echo         Write-Host "" >> "%PS%"
echo         Write-Host "    - Computer name" -ForegroundColor Gray >> "%PS%"
echo         Write-Host "    - Windows version" -ForegroundColor Gray >> "%PS%"
echo         Write-Host "    - CPU name" -ForegroundColor Gray >> "%PS%"
echo         Write-Host "    - Total RAM (GB)" -ForegroundColor Gray >> "%PS%"
echo         Write-Host "    - Local IP address" -ForegroundColor Gray >> "%PS%"
echo         Write-Host "  ===================================" -ForegroundColor DarkGreen >> "%PS%"
echo         Write-Host "" >> "%PS%"
echo         Write-Host "  Do you consent to sending this report?" -ForegroundColor Yellow >> "%PS%"
echo         Write-Host "" >> "%PS%"
echo         for ($i = 0; $i -lt $items.Count; $i++) { >> "%PS%"
echo             if ($i -eq $cur) { Write-Host "   ^>^> $($items[$i])" -ForegroundColor Black -BackgroundColor Yellow } >> "%PS%"
echo             else             { Write-Host "      $($items[$i])" -ForegroundColor Gray } >> "%PS%"
echo         } >> "%PS%"
echo         Write-Host "" >> "%PS%"
echo         Write-Host "  [Up/Down] Move   [Enter] Select" -ForegroundColor DarkGray >> "%PS%"
echo         $key = [Console]::ReadKey($true) >> "%PS%"
echo         if ($key.Key -eq 'UpArrow')   { if ($cur -gt 0) { $cur-- } else { $cur = $items.Count - 1 } } >> "%PS%"
echo         if ($key.Key -eq 'DownArrow') { if ($cur -lt $items.Count - 1) { $cur++ } else { $cur = 0 } } >> "%PS%"
echo         if ($key.Key -eq 'Enter')     { return $cur } >> "%PS%"
echo     } >> "%PS%"
echo } >> "%PS%"
echo. >> "%PS%"

echo $choice = Show-ConsentMenu >> "%PS%"
echo. >> "%PS%"
echo if ($choice -eq 1) { >> "%PS%"
echo     Set-Content -Path $flagFile -Value "!! DO NOT DELETE THIS FILE - it is used by Win2ISO to track diagnostics !!" >> "%PS%"
echo     Add-Content -Path $flagFile -Value "TRUE" >> "%PS%"
echo     Clear-Host >> "%PS%"
echo     Write-Host "" >> "%PS%"
echo     Write-Host "  Diagnostics - System Report Sender" -ForegroundColor Green >> "%PS%"
echo     Write-Host "  ===================================" -ForegroundColor DarkGreen >> "%PS%"
echo     Write-Host "" >> "%PS%"
echo     Write-Host "  Goodbye! [this may take a few seconds]" -ForegroundColor Yellow >> "%PS%"
echo     Write-Host "" >> "%PS%"
echo     Start-Sleep -Seconds 2 >> "%PS%"
echo     exit >> "%PS%"
echo } >> "%PS%"
echo. >> "%PS%"
echo Clear-Host >> "%PS%"
echo Write-Host "" >> "%PS%"
echo Write-Host "  Diagnostics - System Report Sender" -ForegroundColor Green >> "%PS%"
echo Write-Host "  ===================================" -ForegroundColor DarkGreen >> "%PS%"
echo Write-Host "" >> "%PS%"
echo Write-Host "  [*] Collecting info..." -ForegroundColor Yellow >> "%PS%"
echo Write-Host "" >> "%PS%"
echo $pc      = $env:COMPUTERNAME >> "%PS%"
echo $os      = (Get-WmiObject Win32_OperatingSystem).Caption >> "%PS%"
echo $cpu     = (Get-WmiObject Win32_Processor ^| Select-Object -First 1).Name >> "%PS%"
echo $ramGB   = [math]::Round((Get-WmiObject Win32_OperatingSystem).TotalVisibleMemorySize/1MB, 1) >> "%PS%"
echo $localIP = (Get-NetIPAddress -AddressFamily IPv4 ^| Where-Object { $_.InterfaceAlias -notlike '*Loopback*' } ^| Select-Object -First 1).IPAddress >> "%PS%"
echo. >> "%PS%"


echo Write-Host "  OS      : $os"         -ForegroundColor White >> "%PS%"
echo Write-Host "  CPU     : $cpu"        -ForegroundColor Yellow >> "%PS%"
echo Write-Host "  RAM     : ${ramGB} GB" -ForegroundColor Yellow >> "%PS%"
echo Write-Host "  PC      : $pc"         -ForegroundColor Yellow >> "%PS%"
echo Write-Host "  IP      : $localIP"    -ForegroundColor DarkGray >> "%PS%"
echo Write-Host "" >> "%PS%"
echo Write-Host "  ========================================" -ForegroundColor Yellow >> "%PS%"
echo Write-Host "  Sending report..." -ForegroundColor Yellow >> "%PS%"
echo Write-Host "  ========================================" -ForegroundColor Yellow >> "%PS%"
echo Write-Host "" >> "%PS%"


echo $body = @{ username = 'Diagnostics'; embeds = @(@{ title = 'Diagnostic Report'; color = 3066993; fields = @( @{ name = 'Computer'; value = $pc; inline = $true }, @{ name = 'OS'; value = $os; inline = $false }, @{ name = 'CPU'; value = $cpu; inline = $false }, @{ name = 'RAM'; value = [string]$ramGB + ' GB'; inline = $true }, @{ name = 'Local IP'; value = $localIP; inline = $true } ) }) } ^| ConvertTo-Json -Depth 10 >> "%PS%"
echo. >> "%PS%"
echo try { >> "%PS%"
echo     Invoke-RestMethod -Uri $webhook -Method Post -ContentType 'application/json' -Body $body -ErrorAction Stop >> "%PS%"
echo     Set-Content -Path $flagFile -Value "!! DO NOT DELETE THIS FILE - it is used by Win2ISO to track diagnostics !!" >> "%PS%"
echo     Add-Content -Path $flagFile -Value "TRUE" >> "%PS%"
echo     Write-Host "  Done! Report sent successfully." -ForegroundColor Green >> "%PS%"

echo     try { >> "%PS%"
echo         [void][Windows.UI.Notifications.ToastNotificationManager,Windows.UI.Notifications,ContentType=WindowsRuntime] >> "%PS%"
echo         $data = [Windows.UI.Notifications.ToastNotificationManager]::GetTemplateContent([Windows.UI.Notifications.ToastTemplateType]::ToastText02) >> "%PS%"
echo         $nodes = $data.GetElementsByTagName('text') >> "%PS%"
echo         [void]$nodes[0].AppendChild($data.CreateTextNode('Diagnostics - Report Sent')) >> "%PS%"
echo         [void]$nodes[1].AppendChild($data.CreateTextNode('Basic system info submitted successfully.')) >> "%PS%"
echo         [Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier('Diagnostics').Show([Windows.UI.Notifications.ToastNotification]::new($data)) >> "%PS%"
echo     } catch {} >> "%PS%"
echo } catch { >> "%PS%"

echo     Set-Content -Path $flagFile -Value "!! DO NOT DELETE THIS FILE - it is used by Win2ISO to track diagnostics !!" >> "%PS%"
echo     Add-Content -Path $flagFile -Value "TRUE" >> "%PS%"
echo     Write-Host "  Send failed! (error: $($_.Exception.Message))" -ForegroundColor Red >> "%PS%"
echo     Write-Host "  Make sure WEBHOOK_ENC is set correctly." -ForegroundColor Yellow >> "%PS%"
echo } >> "%PS%"
echo. >> "%PS%"
echo Write-Host "" >> "%PS%"
echo Write-Host "  Press any key to close..." -ForegroundColor DarkGray >> "%PS%"
echo [Console]::CursorVisible = $false >> "%PS%"
echo [Console]::ReadKey($true) ^| Out-Null >> "%PS%"

powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%PS%"
del "%PS%" 2>nul
endlocal
