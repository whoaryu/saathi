@echo off
echo Finding your computer's IP address...
echo.
echo Your computer's IP addresses:
ipconfig | findstr "IPv4"
echo.
echo Look for the IP address that starts with 192.168.x.x or 10.0.x.x
echo This is likely the IP address you need to use in the Flutter app.
echo.
pause 