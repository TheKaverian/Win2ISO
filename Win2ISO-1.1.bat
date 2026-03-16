@ECHO OFF
rem ============================================================
rem  Win2ISO - Windows ISO Downloader
rem  written by kaverian
rem
rem  if this breaks its not my fault
rem  (its probably your fault)
rem
rem  feel free to poke around, if u see any errors or inconsistencies
rem  make a github error 
rem
rem  i spent way too long on this
rem ============================================================

mode con: cols=80 lines=20
setlocal
title Win2ISO - Windows ISO Downloader

powershell.exe -NoProfile -Command "exit" >nul 2>&1
if errorlevel 1 (
    cls
    color 0C
    echo.
    echo   ERROR: PowerShell Not Found!
    echo   ============================
    echo.
    echo   Expected: powershell.exe in System32
    echo   PowerShell is required to run Win2ISO.
    echo.
    echo   What to do:
    echo   1. Download PowerShell from Microsoft's official website
    echo   2. Install PowerShell on your system
    echo   3. Restart and try this application again
    echo.
    echo   Would you like to open the PowerShell download page?
    echo   [Y] Yes - Open Download Page    [N] No - Exit
    echo.
    choice /C YN /N /M " "
    if errorlevel 2 (
        echo.
        echo   Exiting application.
        echo.
        timeout /t 2 >nul
        exit /b 1
    )
    if errorlevel 1 (
        echo.
        echo   Opening download page...
        echo.
        start https://learn.microsoft.com/en-us/powershell/scripting/install/installing-powershell-on-windows
        timeout /t 2 >nul
        exit /b 1
    )
)

color 07
set "PS=%TEMP%\win2iso.ps1"
set "CURL_INSTALLER=%TEMP%\curl_installer.bat"

del "%PS%" 2>nul

rem bum ass chicken gonna hate 

echo [Console]::CursorVisible = $false >> "%PS%"
echo $host.UI.RawUI.WindowTitle = 'Win2ISO' >> "%PS%"
echo. >> "%PS%"
echo try { >> "%PS%"
echo     $psHost = Get-Host >> "%PS%" rem ping me when ur back
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


echo function Show-Menu($title, $items) { >> "%PS%"
echo     $cur = 0 >> "%PS%"
echo     $scroll = 0 >> "%PS%"
echo     $visibleItems = 10 >> "%PS%"
echo     while ($true) { >> "%PS%"
echo         Clear-Host >> "%PS%"
echo         Write-Host "" >> "%PS%"
echo         Write-Host "  Win2ISO - Windows ISO Downloader" -ForegroundColor Green >> "%PS%"
echo         Write-Host "  =================================" -ForegroundColor DarkGreen >> "%PS%"
echo         Write-Host "" >> "%PS%"
echo         Write-Host "  $title" -ForegroundColor Yellow >> "%PS%"
echo         Write-Host "" >> "%PS%"
echo         if ($cur -ge $scroll + $visibleItems) { $scroll = $cur - $visibleItems + 1 } >> "%PS%"
echo         if ($cur -lt $scroll) { $scroll = $cur } >> "%PS%"
echo         $end = [Math]::Min($scroll + $visibleItems, $items.Count) >> "%PS%"
echo         for ($inner = $scroll; $inner -lt $end; $inner++) { >> "%PS%"
echo             if ($inner -eq $cur) { Write-Host "   ^>^> $($items[$inner])" -ForegroundColor Black -BackgroundColor Yellow } >> "%PS%"
echo             else             { Write-Host "      $($items[$inner])" -ForegroundColor Gray } >> "%PS%"
echo         } >> "%PS%"
echo         Write-Host "" >> "%PS%"
echo         Write-Host "  [Up/Down] Move   [Enter] Select   [Esc] Back" -ForegroundColor DarkGray >> "%PS%"
echo         $key = [Console]::ReadKey($true) >> "%PS%"
echo         if ($key.Key -eq 'UpArrow')   { if ($cur -gt 0) { $cur-- } else { $cur = $items.Count - 1 } } >> "%PS%"
echo         if ($key.Key -eq 'DownArrow') { if ($cur -lt $items.Count - 1) { $cur++ } else { $cur = 0 } } >> "%PS%"
echo         if ($key.Key -eq 'Enter')     { return $cur } >> "%PS%"
echo         if ($key.Key -eq 'Escape')    { return -1 } >> "%PS%"
echo     } >> "%PS%"
echo } >> "%PS%"
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
echo     $host.UI.RawUI.WindowTitle = "Win2ISO - ERROR: No Internet Connection" >> "%PS%"
echo     Clear-Host >> "%PS%"
echo     Write-Host "" >> "%PS%"
echo     Write-Host "  ERROR: No Internet Connection!" -ForegroundColor Red >> "%PS%"
echo     Write-Host "  ==============================" -ForegroundColor DarkRed >> "%PS%"
echo     Write-Host "" >> "%PS%"
echo     Write-Host "  Win2ISO requires an active internet connection." -ForegroundColor Yellow >> "%PS%"
echo     Write-Host "" >> "%PS%"
echo     Write-Host "  What to do:" -ForegroundColor White >> "%PS%"
echo     Write-Host "  1. Check your network connection" -ForegroundColor Gray >> "%PS%"
echo     Write-Host "  2. Connect to WiFi or Ethernet" -ForegroundColor Gray >> "%PS%"
echo     Write-Host "  3. Disable VPN or firewall if blocking internet" -ForegroundColor Gray >> "%PS%"
echo     Write-Host "  4. Restart your router and try again" -ForegroundColor Gray >> "%PS%"
echo     Write-Host "" >> "%PS%"
echo     Write-Host "  Once connected, rerun this application." -ForegroundColor Yellow >> "%PS%"
echo     Write-Host "" >> "%PS%"
echo     [Console]::CursorVisible = $true >> "%PS%"
echo     Read-Host "Press Enter to exit" >> "%PS%"
echo     exit >> "%PS%"
echo } >> "%PS%"
echo. >> "%PS%"

echo $curl = "$env:SystemRoot\System32\curl.exe" >> "%PS%"
echo if (-not (Test-Path $curl)) { >> "%PS%"
echo     $host.UI.RawUI.WindowTitle = "Win2ISO - ERROR: cURL Not Found" >> "%PS%"
echo     Clear-Host >> "%PS%"
echo     Write-Host "" >> "%PS%"
echo     Write-Host "  ERROR: curl.exe not found!" -ForegroundColor Red >> "%PS%"
echo     Write-Host "  ============================" -ForegroundColor DarkRed >> "%PS%"
echo     Write-Host "" >> "%PS%"
echo     Write-Host "  Expected: $env:SystemRoot\System32\curl.exe" -ForegroundColor Yellow >> "%PS%"
echo     Write-Host "  cURL ships with Windows 10 v1803+." -ForegroundColor Gray >> "%PS%"
echo  Write-Host "" -ForegroundColor Gray >> "%PS%"
echo     Write-Host "  Would you like to automatically install cURL?" -ForegroundColor Yellow >> "%PS%"
echo     Write-Host "  [Y] Yes - Install cURL    [N] No - Exit" -ForegroundColor Gray >> "%PS%"
echo     Write-Host "" >> "%PS%"
echo     [Console]::CursorVisible = $true >> "%PS%"
echo     $key = [Console]::ReadKey($true) >> "%PS%"
echo     if ($key.Key -eq 'Y') { >> "%PS%"
echo         Write-Host "" >> "%PS%"
echo         Write-Host "  Starting cURL installer..." -ForegroundColor Yellow >> "%PS%"
echo         Write-Host "" >> "%PS%"
echo         Start-Process -FilePath "$env:TEMP\curl_installer.bat" -NoNewWindow -Wait >> "%PS%"
echo         Write-Host "" >> "%PS%"
echo         Write-Host "  Installer finished. Checking for cURL..." -ForegroundColor Yellow >> "%PS%"
echo         Start-Sleep -Seconds 2 >> "%PS%"
echo         if (-not (Test-Path $curl)) { >> "%PS%"
echo             Write-Host "" >> "%PS%"
echo             Write-Host "  ERROR: cURL installation failed or was cancelled." -ForegroundColor Red >> "%PS%"
echo             Write-Host "  Exiting application." -ForegroundColor Red >> "%PS%"
echo            Write-Host "" >> "%PS%"
echo             [Console]::CursorVisible = $true >> "%PS%"
echo             Read-Host "Press Enter to exit" >> "%PS%"
echo             exit >> "%PS%"
echo         } >> "%PS%"
echo         Write-Host "  cURL installed successfully! Continuing..." -ForegroundColor Green >> "%PS%"
echo         Start-Sleep -Seconds 2 >> "%PS%"
echo     } else { >> "%PS%"
echo         Write-Host "" >> "%PS%"
echo         Write-Host "  cURL is required to download ISOs." -ForegroundColor Red >> "%PS%"
echo         Write-Host "  Exiting application." -ForegroundColor Red >> "%PS%"
echo         Write-Host "" >> "%PS%"
echo         [Console]::CursorVisible = $true >> "%PS%"
echo         Read-Host "Press Enter to exit" >> "%PS%"
echo         exit >> "%PS%"
echo     } >> "%PS%"
echo } >> "%PS%"
echo. >> "%PS%"

rem if you know a better mirror link please send me a message at kaverian61@icloud.com or kaverian@proton.me

rem --- Vista ---
echo $vista_ed  = @('Starter [RTM] - x86 only','Home Basic [RTM]','Home Premium [RTM]','Business [RTM]','Ultimate [RTM]','Starter [SP1] - x86 only','Home Basic [SP1]','Home Premium [SP1]','Business [SP1]','Ultimate [SP1]','Starter [SP2] - x86 only','Home Basic [SP2]','Home Premium [SP2]','Business [SP2]','Ultimate [SP2]','Back') >> "%PS%"
echo $vista_x86 = @('https://archive.org/download/en_windows_vista_x86_dvd_x12-34293_202010/en_windows_vista_x86_dvd_x12-34293.iso','https://archive.org/download/en_windows_vista_x86_dvd_x12-34293_202010/en_windows_vista_x86_dvd_x12-34293.iso','https://archive.org/download/en_windows_vista_x86_dvd_x12-34293_202010/en_windows_vista_x86_dvd_x12-34293.iso','https://archive.org/download/en_windows_vista_x86_dvd_x12-34293_202010/en_windows_vista_x86_dvd_x12-34293.iso','https://archive.org/download/en_windows_vista_x86_dvd_x12-34293_202010/en_windows_vista_x86_dvd_x12-34293.iso','https://archive.org/download/windows-vista-starter-sp-1/Windows%20Vista%20Starter%20SP1.iso','https://archive.org/download/en_windows_vista_with_service_pack_1_x86_dvd_x14-29594_202010/en_windows_vista_with_service_pack_1_x86_dvd_x14-29594.iso','https://archive.org/download/en_windows_vista_with_service_pack_1_x86_dvd_x14-29594_202010/en_windows_vista_with_service_pack_1_x86_dvd_x14-29594.iso','https://archive.org/download/en_windows_vista_with_service_pack_1_x86_dvd_x14-29594_202010/en_windows_vista_with_service_pack_1_x86_dvd_x14-29594.iso','https://archive.org/download/en_windows_vista_with_service_pack_1_x86_dvd_x14-29594_202010/en_windows_vista_with_service_pack_1_x86_dvd_x14-29594.iso','https://archive.org/download/windows-vista-starter-sp-2/Windows%20Vista%20Starter%20SP2.iso','https://archive.org/download/en_windows_vista_sp2_x86_dvd_342266/en_windows_vista_sp2_x86_dvd_342266.iso','https://archive.org/download/en_windows_vista_sp2_x86_dvd_342266/en_windows_vista_sp2_x86_dvd_342266.iso','https://archive.org/download/en_windows_vista_sp2_x86_dvd_342266/en_windows_vista_sp2_x86_dvd_342266.iso','https://archive.org/download/en_windows_vista_sp2_x86_dvd_342266/en_windows_vista_sp2_x86_dvd_342266.iso') >> "%PS%"
echo $vista_x64 = @('NONE','https://archive.org/download/en_windows_vista_x64_dvd_x12-40712_202010/en_windows_vista_x64_dvd_x12-40712.iso','https://archive.org/download/en_windows_vista_x64_dvd_x12-40712_202010/en_windows_vista_x64_dvd_x12-40712.iso','https://archive.org/download/en_windows_vista_x64_dvd_x12-40712_202010/en_windows_vista_x64_dvd_x12-40712.iso','https://archive.org/download/en_windows_vista_x64_dvd_x12-40712_202010/en_windows_vista_x64_dvd_x12-40712.iso','NONE','https://archive.org/download/en_windows_vista_with_service_pack_1_x64_dvd_x14-29595_202010/en_windows_vista_with_service_pack_1_x64_dvd_x14-29595.iso','https://archive.org/download/en_windows_vista_with_service_pack_1_x64_dvd_x14-29595_202010/en_windows_vista_with_service_pack_1_x64_dvd_x14-29595.iso','https://archive.org/download/en_windows_vista_with_service_pack_1_x64_dvd_x14-29595_202010/en_windows_vista_with_service_pack_1_x64_dvd_x14-29595.iso','https://archive.org/download/en_windows_vista_with_service_pack_1_x64_dvd_x14-29595_202010/en_windows_vista_with_service_pack_1_x64_dvd_x14-29595.iso','NONE','https://archive.org/download/en_windows_vista_sp2_x64_dvd_342267_202010/en_windows_vista_sp2_x64_dvd_342267.iso','https://archive.org/download/en_windows_vista_sp2_x64_dvd_342267_202010/en_windows_vista_sp2_x64_dvd_342267.iso','https://archive.org/download/en_windows_vista_sp2_x64_dvd_342267_202010/en_windows_vista_sp2_x64_dvd_342267.iso','https://archive.org/download/en_windows_vista_sp2_x64_dvd_342267_202010/en_windows_vista_sp2_x64_dvd_342267.iso') >> "%PS%"
echo. >> "%PS%"

rem --- Windows 7 ---
echo $win7_ed   = @('Starter [RTM] - x86 only','Home Premium [RTM] - x64 is Dell OEM','Professional [RTM]','Ultimate [RTM]','Home Premium [SP1]','Professional [SP1]','Ultimate [SP1]','All-In-One [SP1]','Back') >> "%PS%"
echo $win7_x86  = @('https://archive.org/download/windows_7_starter_n_x86_rtm_english/en_windows_7_starter_n_x86_dvd_x16-15928.iso','https://archive.org/download/Windows7HomePremiumRTMx86/Windows%207%20Home%20Premium%20RTM%20%28GRMCHPFREO_EN_DVD%29.iso','https://archive.org/download/Win_7_RTM_Pro_X86/en_windows_7_professional_x86_dvd_x15-65804.iso','https://archive.org/download/en_windows_7_ultimate_x86_dvd_x15-65921_201902/en_windows_7_ultimate_x86_dvd_x15-65921.iso','https://archive.org/download/windows-7-home-prem-english/Win7_HomePrem_SP1_English_x32.iso','https://archive.org/download/win-7-pro-sp1-english/Win7_Pro_SP1_English_x32.iso','https://archive.org/download/win-7-ult-sp1-english/Win7_Ult_SP1_English_x32.iso','https://archive.org/download/windows-7-aio-sp-1/Windows%207%20AIO%20SP1.ISO') >> "%PS%"
echo $win7_x64  = @('NONE','https://archive.org/download/Windows7HomePremiumRTMx64DellOEM/Dell_Windows_7_Home_Premium_RTM_x64.iso','https://archive.org/download/Win7ProRTMx64/Windows%207%20Professional%20RTM%20x64%20%28Enu%29.iso','https://archive.org/download/Windows7UltimateRTMx64/en_windows_7_ultimate_x64_dvd_x15-65922.iso','https://archive.org/download/windows-7-home-prem-english/Win7_HomePrem_SP1_English_x64.iso','https://archive.org/download/win-7-pro-sp1-english/Win7_Pro_SP1_English_x64.iso','https://archive.org/download/win-7-ult-sp1-english/Win7_Ult_SP1_English_x64.iso','https://archive.org/download/windows-7-all-in-one/Windows_7_All_In_One.ISO') >> "%PS%"
echo. >> "%PS%"

rem --- Windows 8 / 8.1 ---
echo $win8_ed   = @('Windows 8 [RTM]','Windows 8 Pro [RTM]','Windows 8.1 [RTM]','Windows 8.1 Pro [RTM]','Windows 8.1 [Update 1]','Windows 8.1 Pro [Update 1]','Windows 8.1 Enterprise [Update 1]','Windows 8.1 AIO [Update 1]','Back') >> "%PS%"
echo $win8_x86  = @('https://archive.org/download/Windows-EIGHT-Collection/en_windows_8_debug_checked_build_x64_dvd_917558.iso','https://archive.org/download/Windows-EIGHT-Collection/en_windows_8_pro_vl_x86_dvd_917830.iso','https://archive.org/download/windows-8.1-msdn-iso-files-en-de-ru-tr-x86-x64/tr_windows_8_1_x86_dvd_2707500.iso','https://archive.org/download/windows-8.1-msdn-iso-files-en-de-ru-tr-x86-x64/tr_windows_8_1_x86_dvd_2707500.iso','https://archive.org/download/win-8.1/Win8.1_EnglishInternational_x32.iso','https://archive.org/download/win-8.1/Win8.1_EnglishInternational_x32.iso','https://archive.org/download/win-8.1-english-data-64-data-86/Win8.1_English_x32.iso','https://archive.org/download/win-8.1-english-data-64-data-86/Win8.1_English_x32.iso') >> "%PS%"
echo $win8_x64  = @('https://archive.org/download/Windows-EIGHT-Collection/en_windows_8_debug_checked_build_x64_dvd_917558.iso','https://archive.org/download/Windows-EIGHT-Collection/en_windows_8_n_x64_dvd_916091.iso','https://archive.org/download/windows-8.1-msdn-iso-files-en-de-ru-tr-x86-x64/tr_windows_8_1_x86_dvd_2707500.iso','https://archive.org/download/windows-8.1-msdn-iso-files-en-de-ru-tr-x86-x64/tr_windows_8_1_x86_dvd_2707500.iso','https://archive.org/download/win-8.1/Win8.1_EnglishInternational_x64.iso','https://archive.org/download/win-8.1/Win8.1_EnglishInternational_x64.iso','https://archive.org/download/win-8.1-english-data-64-data-86/Win8.1_English_x64.iso','https://archive.org/download/Win81AIOx64UpdatedJune2019/W81X64.AIO.ENU.JUN2019.iso') >> "%PS%"
echo. >> "%PS%"

rem --- Windows 10 ---
echo $win10_ed  = @('Windows 10 Home 1507','Windows 10 Pro 1507','Windows 10 Home 1511','Windows 10 Pro 1511','Windows 10 Home 1607','Windows 10 Pro 1607','Windows 10 Home 1703','Windows 10 Pro 1703','Windows 10 Home 1709','Windows 10 Pro 1709','Windows 10 Home 1803','Windows 10 Pro 1803','Windows 10 Home 1809','Windows 10 Pro 1809','Windows 10 Home 1903','Windows 10 Pro 1903','Windows 10 Home 2004','Windows 10 Pro 2004','Windows 10 Home 20H2','Windows 10 Pro 20H2','Windows 10 Home 21H1','Windows 10 Pro 21H1','Windows 10 Home 21H2','Windows 10 Pro 21H2','Windows 10 Home 22H2','Windows 10 Pro 22H2','Back') >> "%PS%"
echo $win10_x86 = @('https://archive.org/download/windows-10-1507-home-and-pro/Win10_EnglishInternational_x32.iso','https://archive.org/download/windows-10-1507-home-and-pro/Win10_EnglishInternational_x32.iso','https://archive.org/download/win10-1511/Win10_1511_EnglishInternational_x32.iso','https://archive.org/download/win10-1511/Win10_1511_EnglishInternational_x32.iso','https://archive.org/download/win10-1607/Win10_1607_EnglishInternational_x32.iso','https://archive.org/download/win10-1607/Win10_1607_EnglishInternational_x32.iso','https://archive.org/download/Windows-10-1703-french/413%20June%202017/en_windows_10_multiple_editions_version_1703_updated_june_2017_x86_dvd_10725453.iso','https://archive.org/download/Windows-10-1703-french/015%20March%202017/English/SW_DVD5_Win_Pro_10_1703_32BIT_English_MLF_X21-36725.ISO','https://archive.org/download/fr_windows_10_multi-edition_vl_version_1709_updated_sept_2017_x86_x64/015%20September%202017/en_windows_10_multi-edition_version_1709_updated_sept_2017_x86_dvd_100090818.iso','https://archive.org/download/fr_windows_10_multi-edition_vl_version_1709_updated_sept_2017_x86_x64/015%20September%202017/en_windows_10_multi-edition_version_1709_updated_sept_2017_x86_dvd_100090818.iso','https://archive.org/download/fr_windows_10_business_editions_version_1803_updated_march_2018_x86_x64/0112%20July%202018/en_windows_10_consumer_edition_version_1803_updated_jul_2018_x86_dvd_12711391.iso','https://archive.org/download/fr_windows_10_business_editions_version_1803_updated_march_2018_x86_x64/0112%20July%202018/en_windows_10_consumer_edition_version_1803_updated_jul_2018_x86_dvd_12711391.iso','https://archive.org/download/windows-10-1809-frnehc/0107-september_2018/en_windows_10_consumer_edition_version_1809_updated_sept_2018_x86_dvd_c5960600.iso','https://archive.org/download/windows-10-1809-frnehc/0107-september_2018/en_windows_10_consumer_edition_version_1809_updated_sept_2018_x86_dvd_c5960600.iso','https://archive.org/download/windows-10-1903-french/0175-June_2019/en_windows_10_consumer_edition_version_1903_updated_june_2019_x86_dvd_d075e11d.iso','https://archive.org/download/windows-10-1903-french/0175-June_2019/en_windows_10_consumer_edition_version_1903_updated_june_2019_x86_dvd_d075e11d.iso','https://archive.org/download/windows-10-2004-home-pro-english-data-86/Windows%2010%202004%20Home-Pro%20English%20x86.iso','https://archive.org/download/windows-10-2004-home-pro-english-data-86/Windows%2010%202004%20Home-Pro%20English%20x86.iso','https://archive.org/download/fr_windows_10_business_editions_version_20h2_x86_x64/0508/en_windows_10_consumer_editions_version_20h2_x86_dvd_ea9a9e3f.iso','https://archive.org/download/fr_windows_10_business_editions_version_20h2_x86_x64/0508/en_windows_10_consumer_editions_version_20h2_x86_dvd_ea9a9e3f.iso','https://archive.org/download/Windows10-21h1-french/0928/en_windows_10_consumer_editions_version_21h1_x86_dvd_68cee121.iso','https://archive.org/download/Windows10-21h1-french/0928/en_windows_10_consumer_editions_version_21h1_x86_dvd_68cee121.iso','https://archive.org/download/fr-fr_windows_10_business_editions_version_21h2_x86_x64/1288/en-us_windows_10_consumer_editions_version_21h2_x86_dvd_31755f1b.iso','https://archive.org/download/fr-fr_windows_10_business_editions_version_21h2_x86_x64/1288/en-us_windows_10_consumer_editions_version_21h2_x86_dvd_31755f1b.iso','https://archive.org/download/en-us_windows_10_consumer_editions_version_22h2_x86_dvd_90883feb/en-us_windows_10_consumer_editions_version_22h2_x86_dvd_90883feb.iso','https://archive.org/download/en-us_windows_10_consumer_editions_version_22h2_x86_dvd_90883feb/en-us_windows_10_consumer_editions_version_22h2_x86_dvd_90883feb.iso') >> "%PS%"
echo $win10_x64 = @('https://archive.org/download/windows-10-1507-home-and-pro/Win10_EnglishInternational_x64.iso','https://archive.org/download/windows-10-1507-home-and-pro/Win10_EnglishInternational_x64.iso','https://archive.org/download/win10-1511/Win10_1511_EnglishInternational_x64.iso','https://archive.org/download/win10-1511/Win10_1511_EnglishInternational_x64.iso','https://archive.org/download/win10-1607/Win10_1607_EnglishInternational_x64.iso','https://archive.org/download/win10-1607/Win10_1607_EnglishInternational_x64.iso','https://archive.org/download/Windows-10-1703-french/413%20June%202017/en_windows_10_multiple_editions_version_1703_updated_june_2017_x64_dvd_10725021.iso','https://archive.org/download/Windows-10-1703-french/413%20June%202017/en_windows_10_multiple_editions_version_1703_updated_june_2017_x64_dvd_10725021.iso','https://archive.org/download/fr_windows_10_multi-edition_vl_version_1709_updated_sept_2017_x86_x64/015%20September%202017/en_windows_10_multi-edition_version_1709_updated_sept_2017_x64_dvd_100090817.iso','https://archive.org/download/fr_windows_10_multi-edition_vl_version_1709_updated_sept_2017_x86_x64/015%20September%202017/en_windows_10_multi-edition_version_1709_updated_sept_2017_x64_dvd_100090817.iso','https://archive.org/download/win101803englishx64/Win10_1803_English_x64.iso','https://archive.org/download/win101803englishx64/Win10_1803_English_x64.iso','https://archive.org/download/windows-10-1809-frnehc/0107-september_2018/en_windows_10_consumer_edition_version_1809_updated_sept_2018_x64_dvd_491ea967.iso','https://archive.org/download/windows-10-1809-frnehc/0107-september_2018/en_windows_10_consumer_edition_version_1809_updated_sept_2018_x64_dvd_491ea967.iso','https://archive.org/download/windows-10-1903-french/0175-June_2019/en_windows_10_consumer_edition_version_1903_updated_june_2019_x64_dvd_8d122c90.iso','https://archive.org/download/windows-10-1903-french/0175-June_2019/en_windows_10_consumer_edition_version_1903_updated_june_2019_x64_dvd_8d122c90.iso','https://archive.org/download/win-10-2004-english-data-64_202010/Win10_2004_English_x64.iso','https://archive.org/download/win-10-2004-english-data-64_202010/Win10_2004_English_x64.iso','https://archive.org/download/win-10-20-h2-v2-english-data-64_20210429/Win10_20H2_v2_English_x64.iso','https://archive.org/download/win-10-20-h2-v2-english-data-64_20210429/Win10_20H2_v2_English_x64.iso','https://archive.org/download/Windows10-21h1-french/0928/en_windows_10_consumer_editions_version_21h1_x64_dvd_540c0dd4.iso','https://archive.org/download/Windows10-21h1-french/0928/en_windows_10_consumer_editions_version_21h1_x64_dvd_540c0dd4.iso','https://archive.org/download/fr-fr_windows_10_business_editions_version_21h2_x86_x64/1288/en-us_windows_10_consumer_editions_version_21h2_x64_dvd_6cfdb144.iso','https://archive.org/download/fr-fr_windows_10_business_editions_version_21h2_x86_x64/1288/en-us_windows_10_consumer_editions_version_21h2_x64_dvd_6cfdb144.iso','https://archive.org/download/en-us_windows_10_consumer_editions_version_22h2_updated_feb_2023_x64_dvd_c29e4bb3/en-us_windows_10_consumer_editions_version_22h2_updated_feb_2023_x64_dvd_c29e4bb3.iso','https://archive.org/download/en-us_windows_10_consumer_editions_version_22h2_updated_feb_2023_x64_dvd_c29e4bb3/en-us_windows_10_consumer_editions_version_22h2_updated_feb_2023_x64_dvd_c29e4bb3.iso') >> "%PS%"
echo. >> "%PS%"

rem --- Windows 11 ---
rem TODO: find actual skig archive placeholders 
echo $win11_ed  = @('21H2 - Initial Release (Oct 2021)','22H2 - 2022 Update','23H2 - 2023 Update','24H2 - 2024 Update','IoT LTSC 2024','Back') >> "%PS%"
echo $win11_x64 = @('https://PLACEHOLDER/win11_21h2_x64.iso','https://PLACEHOLDER/win11_22h2_x64.iso','https://PLACEHOLDER/win11_23h2_x64.iso','https://PLACEHOLDER/win11_24h2_x64.iso','https://PLACEHOLDER/win11_ltsc24_x64.iso') >> "%PS%"
echo. >> "%PS%"

rem --- Windows Server ---
rem TODO: fill in these PLACEHOLDERs
echo $winserver_ed  = @('Windows Server 2008','Windows Server 2008 R2','Windows Server 2012','Windows Server 2012 R2','Windows Server 2016 - x64 only','Windows Server 2019 - x64 only','Windows Server 2022 - x64 only','Windows Server 2025 - x64 only','Back') >> "%PS%"
echo $winserver_x86 = @('https://PLACEHOLDER/winserver_2008_x86.iso','https://PLACEHOLDER/winserver_2008r2_x86.iso','https://PLACEHOLDER/winserver_2012_x86.iso','https://PLACEHOLDER/winserver_2012r2_x86.iso','NONE','NONE','NONE','NONE') >> "%PS%"
echo $winserver_x64 = @('https://PLACEHOLDER/winserver_2008_x64.iso','https://PLACEHOLDER/winserver_2008r2_x64.iso','https://PLACEHOLDER/winserver_2012_x64.iso','https://PLACEHOLDER/winserver_2012r2_x64.iso','https://PLACEHOLDER/winserver_2016_x64.iso','https://PLACEHOLDER/winserver_2019_x64.iso','https://PLACEHOLDER/winserver_2022_x64.iso','https://PLACEHOLDER/winserver_2025_x64.iso') >> "%PS%"
echo. >> "%PS%"


echo $winltsc_ed  = @('Windows 7 Enterprise','Windows 10 Enterprise LTSC 2015 - x64 only','Windows 10 Enterprise LTSC 2016 - x64 only','Windows 10 Enterprise LTSC 2019 - x64 only','Windows 10 Enterprise LTSC 2021 - x64 only','Windows 11 Enterprise LTSC 2024 - x64 only','Back') >> "%PS%"
echo $winltsc_x86 = @('https://PLACEHOLDER/win7_ent_x86.iso','NONE','NONE','NONE','NONE','NONE') >> "%PS%"
echo $winltsc_x64 = @('https://PLACEHOLDER/win7_ent_x64.iso','https://PLACEHOLDER/win10_ltsc_2015_x64.iso','https://PLACEHOLDER/win10_ltsc_2016_x64.iso','https://PLACEHOLDER/win10_ltsc_2019_x64.iso','https://PLACEHOLDER/win10_ltsc_2021_x64.iso','https://PLACEHOLDER/win11_ltsc_2024_x64.iso') >> "%PS%"
echo. >> "%PS%"

rem top-level OS list - this is what the user sees first
echo $os_names = @('Windows Vista','Windows 7','Windows 8 / 8.1','Windows 10','Windows 11','Windows Server','Windows LTSC','Exit') >> "%PS%"
echo. >> "%PS%"
echo while ($true) { >> "%PS%"
echo     $o = Show-Menu 'Select a Windows version' $os_names >> "%PS%"
echo     if ($o -eq -1 -or $o -eq 7) { break } >> "%PS%"

echo     switch ($o) { >> "%PS%"
echo         0 { $eds=$vista_ed;  $ax=$vista_x86;  $bx=$vista_x64;  $needArch=$true  } >> "%PS%"
echo         1 { $eds=$win7_ed;   $ax=$win7_x86;   $bx=$win7_x64;   $needArch=$true  } >> "%PS%"
echo         2 { $eds=$win8_ed;   $ax=$win8_x86;   $bx=$win8_x64;   $needArch=$true  } >> "%PS%"
echo         3 { $eds=$win10_ed;  $ax=$win10_x86;  $bx=$win10_x64;  $needArch=$true  } >> "%PS%"
echo         4 { $eds=$win11_ed;  $ax=$null;       $bx=$win11_x64;  $needArch=$false } >> "%PS%"
echo         5 { $eds=$winserver_ed;  $ax=$winserver_x86;  $bx=$winserver_x64;  $needArch=$true  } >> "%PS%"
echo         6 { $eds=$winltsc_ed;    $ax=$winltsc_x86;    $bx=$winltsc_x64;    $needArch=$true  } >> "%PS%"
echo     } >> "%PS%"
echo     $goBackToOS = $false >> "%PS%"
echo     while ($true) { >> "%PS%"
echo         $e = Show-Menu $os_names[$o] $eds >> "%PS%"
echo         if ($e -eq -1) { $goBackToOS = $true; break } >> "%PS%"
echo         if ($eds[$e] -eq 'Back') { break } >> "%PS%"
echo         $url  = '' >> "%PS%"
echo         $arch = '' >> "%PS%"

echo         if ($needArch) { >> "%PS%"
echo             while ($true) { >> "%PS%"
echo                 if ($eds[$e] -like '*x86 only*') { >> "%PS%"
echo                     $archMenu = @('x86  (32-bit)','Back') >> "%PS%"
echo                 } else { >> "%PS%"
echo                     $archMenu = @('x86  (32-bit)','x64  (64-bit)','Back') >> "%PS%"
echo                 } >> "%PS%"
echo                 $a = Show-Menu "$($os_names[$o]) / $($eds[$e])" $archMenu >> "%PS%"
echo                 if ($a -eq -1) { break } >> "%PS%"
echo                 if ($a -eq 0) { $arch='x86'; $url=$ax[$e]; break } >> "%PS%"
echo                 if ($a -eq 1 -and $archMenu[$a] -ne 'Back') { $arch='x64'; $url=$bx[$e]; break } >> "%PS%"
echo                 if ($archMenu[$a] -eq 'Back') { break } >> "%PS%"
echo             } >> "%PS%"
echo             if ($a -eq -1) { continue } >> "%PS%"


echo             if ($url -eq 'NONE') { >> "%PS%"
echo                 Clear-Host >> "%PS%"
echo                 Write-Host "" >> "%PS%"
echo                 if ($eds[$e] -like '*x86 only*') { >> "%PS%"
echo                     Write-Host "  This edition is only available in x86 (32-bit)." -ForegroundColor Red >> "%PS%"
echo                 } else { >> "%PS%"
echo                     Write-Host "  No $($arch) variant for this edition." -ForegroundColor Red >> "%PS%"
echo                 } >> "%PS%"
echo                 Write-Host "  Press any key to go back." -ForegroundColor DarkGray >> "%PS%"
echo                 [Console]::ReadKey($true) ^| Out-Null >> "%PS%"
echo                 continue >> "%PS%"
echo             } >> "%PS%"
echo         } else { >> "%PS%"
echo             $arch='x64' >> "%PS%"
echo             $url=$bx[$e] >> "%PS%"
echo         } >> "%PS%"
echo         break >> "%PS%"
echo     } >> "%PS%"
echo     if ($goBackToOS) { continue } >> "%PS%"

echo     Clear-Host >> "%PS%"
echo     Write-Host "" >> "%PS%"
echo     Write-Host "  Win2ISO - Windows ISO Downloader" -ForegroundColor Green >> "%PS%"
echo     Write-Host "  =================================" -ForegroundColor DarkGreen >> "%PS%"
echo     Write-Host "" >> "%PS%"
echo     Write-Host "  OS      : $($os_names[$o])" -ForegroundColor White >> "%PS%"
echo     Write-Host "  Edition : $($eds[$e])"      -ForegroundColor Yellow >> "%PS%"
echo     Write-Host "  Arch    : $arch"             -ForegroundColor Yellow >> "%PS%"
echo     Write-Host "  URL     : $url"              -ForegroundColor DarkGray >> "%PS%"

echo     if ($eds[$e] -like '*8.1 Pro [RTM]*') { >> "%PS%"
echo         Write-Host "" >> "%PS%"
echo         Write-Host "  Product Key: XHQ8N-C3MCJ-RQXB6-WCHYG-C9WKB" -ForegroundColor Cyan >> "%PS%"
echo     } elseif (($eds[$e] -like '*Starter*' -and $os_names[$o] -eq 'Windows Vista') -or ($eds[$e] -eq 'Windows 8.1 [RTM]')) { >> "%PS%"
echo         Write-Host "" >> "%PS%"
echo         if ($eds[$e] -like '*Starter*' -and $os_names[$o] -eq 'Windows Vista') { >> "%PS%"
echo             Write-Host "  Product Key: X9PYV-YBQRV-9BXWV-TQDMK-QDWK4" -ForegroundColor Cyan >> "%PS%"
echo         } elseif ($eds[$e] -eq 'Windows 8.1 [RTM]') { >> "%PS%"
echo             Write-Host "  Product Key: 334NH-RXG76-64THK-C7CKG-D3VPT" -ForegroundColor Cyan >> "%PS%"
echo         } >> "%PS%"
echo     } >> "%PS%"
echo     Write-Host "" >> "%PS%"

echo     Add-Type -AssemblyName System.Windows.Forms >> "%PS%"
echo     $folderBrowser = New-Object System.Windows.Forms.FolderBrowserDialog >> "%PS%"
echo     $folderBrowser.Description = 'Select folder to save ISO' >> "%PS%"
echo     $folderBrowser.ShowNewFolderButton = $true >> "%PS%"
echo     if ($folderBrowser.ShowDialog() -ne 'OK') { >> "%PS%"
echo         Clear-Host >> "%PS%"
echo         Write-Host "" >> "%PS%"
echo         Write-Host "  No folder selected." -ForegroundColor Yellow >> "%PS%"
echo         Write-Host "" >> "%PS%"
echo         Write-Host "  Press Enter to go back to edition selection." -ForegroundColor DarkGray >> "%PS%"
echo         Write-Host "" >> "%PS%"
echo         [Console]::ReadKey($true) ^| Out-Null >> "%PS%"
echo         continue >> "%PS%"
echo     } >> "%PS%"
echo     $dir = $folderBrowser.SelectedPath >> "%PS%"
echo     $fname = [IO.Path]::GetFileName($url) >> "%PS%"
echo     $out   = [IO.Path]::Combine($dir, $fname) >> "%PS%"
echo     Write-Host "" >> "%PS%"
echo     Write-Host "  ========================================" -ForegroundColor Yellow >> "%PS%"
echo     Write-Host "  IMPORTANT: Keep this window OPEN!" -ForegroundColor Red >> "%PS%"
echo     Write-Host "  Do not close until download completes." -ForegroundColor Red >> "%PS%"
echo     Write-Host "  ========================================" -ForegroundColor Yellow >> "%PS%"
echo     Write-Host "" >> "%PS%"
echo     Write-Host "  Downloading..." -ForegroundColor Yellow >> "%PS%"
echo     Write-Host "" >> "%PS%"

echo     $downloadCancelled = $false >> "%PS%"
echo     $p = New-Object Diagnostics.ProcessStartInfo >> "%PS%"
echo     $p.FileName = $curl >> "%PS%"
echo     $p.Arguments = "--progress-bar --location --retry 3 --output `"$out`" `"$url`"" >> "%PS%"
echo     $p.UseShellExecute = $false >> "%PS%"
echo     $proc = [Diagnostics.Process]::Start($p) >> "%PS%"
echo. >> "%PS%"

echo     while (-not $proc.HasExited) { >> "%PS%"
echo         if ([System.Console]::KeyAvailable) { >> "%PS%"
echo             $key = [System.Console]::ReadKey($true) >> "%PS%"
echo             if ($key.Key -eq 'Escape') { >> "%PS%"
echo                 $result = [System.Windows.Forms.MessageBox]::Show("Download in progress!`total`nAre you sure you want to cancel and go back?", "Confirm Cancel", [System.Windows.Forms.MessageBoxButtons]::YesNo, [System.Windows.Forms.MessageBoxIcon]::Warning) >> "%PS%"
echo                 if ($result -eq 'Yes') { >> "%PS%"
echo                     $proc.Kill() >> "%PS%"
echo                     $downloadCancelled = $true >> "%PS%"
echo                     break >> "%PS%"
echo                 } >> "%PS%"
echo             } >> "%PS%"
echo         } >> "%PS%"
echo         Start-Sleep -Milliseconds 100 >> "%PS%"
echo     } >> "%PS%"
echo     if (-not $downloadCancelled) { >> "%PS%"
echo         $proc.WaitForExit() >> "%PS%"
echo     } >> "%PS%"
echo     Write-Host "" >> "%PS%"
echo     if ($downloadCancelled) { >> "%PS%"
echo         Write-Host "  Download cancelled. Returning to edition selection..." -ForegroundColor Yellow >> "%PS%"
echo         Start-Sleep -Seconds 1 >> "%PS%"
echo         continue >> "%PS%"
echo     } >> "%PS%"
echo     if ($proc.ExitCode -eq 0) { >> "%PS%"
echo         Write-Host "  Done! Saved to: $out" -ForegroundColor Green >> "%PS%"

echo         try { >> "%PS%"
echo             [void][Windows.UI.Notifications.ToastNotificationManager,Windows.UI.Notifications,ContentType=WindowsRuntime] >> "%PS%"
echo             $data = [Windows.UI.Notifications.ToastNotificationManager]::GetTemplateContent([Windows.UI.Notifications.ToastTemplateType]::ToastText02) >> "%PS%"
echo             $total = $data.GetElementsByTagName('text') >> "%PS%"
echo             [void]$total[0].AppendChild($data.CreateTextNode('Win2ISO - Download Complete')) >> "%PS%"
echo             [void]$total[1].AppendChild($data.CreateTextNode("$($eds[$e]) ($arch) saved.")) >> "%PS%"
echo             [Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier('Win2ISO').Show([Windows.UI.Notifications.ToastNotification]::new($data)) >> "%PS%"
echo         } catch {} >> "%PS%"
echo     } else { >> "%PS%"
echo         Write-Host "  Download failed! (exit: $($proc.ExitCode))" -ForegroundColor Red >> "%PS%"
echo         Write-Host "  Make sure the URL is not still a PLACEHOLDER." -ForegroundColor Yellow >> "%PS%"
echo     } >> "%PS%"
echo     Write-Host "" >> "%PS%"
echo     Write-Host "  Press any key to return to menu..." -ForegroundColor DarkGray >> "%PS%"
echo     [Console]::ReadKey($true) ^| Out-Null >> "%PS%"
echo     [Console]::CursorVisible = $false >> "%PS%"
echo } >> "%PS%"

rem will fix later
echo Clear-Host >> "%PS%"
echo Write-Host "" >> "%PS%"
echo Write-Host "  Are you sure?" -ForegroundColor Yellow >> "%PS%"
echo Write-Host "  Closing in 10 seconds..." -ForegroundColor Gray >> "%PS%"
echo Write-Host "  Press any key to cancel." -ForegroundColor DarkGray >> "%PS%"
echo Write-Host "" >> "%PS%"
echo [Console]::CursorVisible = $true >> "%PS%"
echo $timeout = $true >> "%PS%"
echo for ($index = 10; $index -gt 0; $index--) { >> "%PS%"
echo     Write-Host "  $index" -ForegroundColor Cyan >> "%PS%"
echo     $sw = [System.Diagnostics.Stopwatch]::StartNew() >> "%PS%"
echo     while ($sw.Elapsed.TotalSeconds -lt 1) { >> "%PS%"
echo         if ([System.Console]::KeyAvailable) { >> "%PS%"
echo             $key = [Console]::ReadKey($true) >> "%PS%"
echo             $timeout = $false >> "%PS%"
echo             $sw.Stop() >> "%PS%"
echo             break >> "%PS%"
echo         } >> "%PS%"
echo         Start-Sleep -Milliseconds 100 >> "%PS%"
echo     } >> "%PS%"
echo     if (-not $timeout) { break } >> "%PS%"
echo     $cursorTop = [Console]::CursorTop >> "%PS%"
echo     [Console]::SetCursorPosition(0, $cursorTop - 1) >> "%PS%"
echo } >> "%PS%"
echo if (-not $timeout) { >> "%PS%"
echo     Clear-Host >> "%PS%"
echo     Write-Host "" >> "%PS%"
echo     Write-Host "  Cancelled. Returning to menu..." -ForegroundColor Green >> "%PS%"
echo     Write-Host "" >> "%PS%"
echo     Start-Sleep -Milliseconds 500 >> "%PS%"
echo } >> "%PS%"
echo [Console]::CursorVisible = $false >> "%PS%"

rem this writes a new script in temp
del "%CURL_INSTALLER%" 2>nul
(
    echo @echo off
    echo setlocal EnableDelayedExpansion
    echo.
    echo net session ^>nul 2^>^&1
    echo if %%errorLevel%% NEQ 0 (
    echo     echo [INFO] Requesting administrator privileges...
    echo     powershell -NoProfile -ExecutionPolicy Bypass -Command "Start-Process -FilePath '%%~f0' -Verb RunAs"
    echo     exit /b
    echo ^)
    echo.
    echo echo ============================================
    echo echo              cURL Installer
    echo echo ============================================
    echo echo.
    echo.
    echo curl --version ^>nul 2^>^&1
    echo if %%errorLevel%% EQU 0 (
    echo     echo [INFO] curl is already installed:
    echo     curl --version ^| findstr /index "curl"
    echo     echo.
    echo     choice /C YN /M "Do you want to reinstall/update curl?"
    echo     if !errorLevel! EQU 2 (
    echo         echo Exiting...
    echo         pause
    echo         exit /b 0
    echo     ^)
    echo ^)
    echo.
    echo set "INSTALL_DIR=%%SYSTEMROOT%%\System32"
    echo set "TEMP_DIR=%%TEMP%%\curl_install"
    echo set "CURL_ZIP=%%TEMP_DIR%%\curl.zip"
    echo set "EXTRACT_DIR=%%TEMP_DIR%%\extracted"
    echo.
    echo if exist "%%TEMP_DIR%%" rd /s /q "%%TEMP_DIR%%"
    echo mkdir "%%TEMP_DIR%%"
    echo mkdir "%%EXTRACT_DIR%%"
    echo.
    echo echo [INFO] Downloading curl for Windows ^(64-bit^)...
    echo powershell -NoProfile -ExecutionPolicy Bypass -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri 'https://curl.se/windows/dl-8.11.1_1/curl-8.11.1_1-win64-mingw.zip' -OutFile '%%CURL_ZIP%%' -UseBasicParsing"
    echo.
    echo if not exist "%%CURL_ZIP%%" (
    echo     echo [ERROR] Download failed. Check your internet connection.
    echo     pause
    echo     exit /b 1
    echo ^)
    echo echo [INFO] Download successful.
    echo.
    echo echo [INFO] Extracting archive...
    echo powershell -NoProfile -ExecutionPolicy Bypass -Command "Expand-Archive -LiteralPath '%%CURL_ZIP%%' -DestinationPath '%%EXTRACT_DIR%%' -Force"
    echo.
    echo if %%errorLevel%% NEQ 0 (
    echo     echo [ERROR] Expand-Archive failed.
    echo     pause
    echo     exit /b 1
    echo ^)
    echo.
    echo echo [INFO] Locating curl.exe in bin folder...
    echo set "CURL_BIN_SRC="
    echo for /r "%%EXTRACT_DIR%%" %%%%F in ^(curl.exe^) do ^(
    echo     echo %%%%~dpF ^| findstr /index "\\bin\\" ^>nul
    echo     if !errorLevel! EQU 0 ^(
    echo         set "CURL_BIN_SRC=%%%%~dpF"
    echo     ^)
    echo ^)
    echo.
    echo if not defined CURL_BIN_SRC (
    echo     echo [ERROR] Could not find curl.exe inside a bin folder.
    echo     echo [DEBUG] All curl.exe locations found:
    echo     for /r "%%EXTRACT_DIR%%" %%%%F in ^(curl.exe^) do echo   %%%%F
    echo     pause
    echo     exit /b 1
    echo ^)
    echo.
    echo echo [INFO] Found bin folder: %%CURL_BIN_SRC%%
    echo.
    echo echo [INFO] Installing to %%INSTALL_DIR%%...
    echo copy /Y "%%CURL_BIN_SRC%%curl.exe" "%%INSTALL_DIR%%\" ^>nul
    echo copy /Y "%%CURL_BIN_SRC%%*.dll"    "%%INSTALL_DIR%%\" ^>nul 2^>^&1
    echo copy /Y "%%CURL_BIN_SRC%%*.crt"    "%%INSTALL_DIR%%\" ^>nul 2^>^&1
    echo.
    echo if not exist "%%INSTALL_DIR%%\curl.exe" (
    echo     echo [ERROR] Failed to copy curl.exe to %%INSTALL_DIR%%.
    echo     pause
    echo     exit /b 1
    echo ^)
    echo.
    echo echo [INFO] Cleaning up temp files...
    echo rd /s /q "%%TEMP_DIR%%" ^>nul 2^>^&1
    echo.
    echo echo.
    echo echo ============================================
    echo echo        Installation Complete!
    echo echo ============================================
    echo echo.
    echo echo Installed to: %%INSTALL_DIR%%\curl.exe
    echo echo.
    echo curl --version
    echo echo.
    echo pause
    echo exit /b 0
) > "%CURL_INSTALLER%"
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%PS%"
del "%PS%" 2>nul
del "%CURL_INSTALLER%" 2>nul
endlocal

rem PLEASE GIVE ME MONEY IM A FUCKING PEASANT; ILL MAKE A DONATION PAGE SOON.