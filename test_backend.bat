@echo off
echo Testing backend accessibility...
echo.
echo Testing localhost...
curl -s http://localhost:5000/api/pets
echo.
echo.
echo Testing network IP...
curl -s http://192.168.29.188:5000/api/pets
echo.
echo.
echo If you see JSON data above, the backend is working correctly.
echo If you see connection errors, check if the backend is running.
echo.
pause 